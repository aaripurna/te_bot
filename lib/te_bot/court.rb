# frozen_string_literal: true

require "rack"
require "json"

module TeBot
  class Court
    include TeBot::Cable

    class << self
      attr_reader :wire, :commands

      def access_token(token)
        @wire = ::TeBot::Wire.new(token)
      end

      def default_command(&block)
        @default_command ||= block
      end

      def default_action(&block)
        @default_action ||= block
      end

      def command(text, &block)
        @commands ||= {}
        @commands[text] = block
      end

      ::TeBot::Message::GENERAL_MESSAGE_TYPES.each do |m|
        define_method(m) do |&block|
          @message_handlers ||= {}

          if block.respond_to?(:call)
            @message_handlers[m] = block
          else
            @message_handlers[m]
          end
        end
      end

      def message_handlers(handler)
        @message_handlers ||= {}
        @message_handlers[handler]
      end
    end

    attr_reader :params, :message, :wire

    def initialize
      @params = {}
      @message = nil
      @command = nil
      @wire = self.class.wire
    end

    def call(env)
      json_only(env) do |body|
        response = handle_request(body)

        case response
        in [Integer, Hash, Array] => rack_response
          rack_response
        in Hash => json_body
          [200, {"Content-Type" => "application/json"}, [JSON.generate(json_body)]]
        else
          [200, {"Content-Type" => "application/json"}, [JSON.generate({"message" => "success"})]]
        end
      end
    end

    private

    def json_only(env)
      unless env["CONTENT_TYPE"]&.start_with?("application/json")
        return [400, {"Content-Type" => "application/json"}, [JSON.generate({"message" => "only accepting application/json"})]]
      end

      req = Rack::Request.new(env)
      body = req.body.read

      return [400, {"Content-Type" => "application/json"}, [JSON.generate({"message" => "Body is required"})]] if body.nil? || body.empty?

      data = JSON.parse(body)

      yield(data)
    end

    def handle_request(body)
      @message = ::TeBot::Message.new(body)

      @command, @params = @message.data&.content&.parse

      @params = params

      @message.command do
        handler = self.class.commands[@command]
        if handler.respond_to?(:call)
          instance_eval(&handler)
        elsif self.class.default_command.respond_to?(:call)
          instance_eval(&self.class.default_command)
        end
      end

      ::TeBot::Message::GENERAL_MESSAGE_TYPES.each do |message_type|
        @message.public_send(message_type) do
          handler = self.class.message_handlers(message_type)

          next unless handler.respond_to?(:call)
          instance_eval(&handler)
        end
      end

      if @message.handler.respond_to?(:call)
        instance_eval(&@message.handler)
      elsif self.class.default_action.respond_to?(:call)
        instance_eval(&self.class.default_action)
      end
    end
  end
end
