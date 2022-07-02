# frozen_string_literal: true

require "rack"
require "json"

module TeBot
  class Court
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
          instance_variable_get("@#{m}") || instance_variable_set("@#{m}", block)
          instance_variable_get("@#{m}")
        end
      end
    end

    def call(env)
      json_only(env) do |body|
        response = handle_request(body)

        if response.is_a?(Array)
          status, headers, body = response
          [status, headers, body]
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
      message = ::TeBot::Message.new(body)

      command, params = message.data&.content&.parse
      conn = ::TeBot::Cable.new(self.class.wire, message, params || {})

      message.command do
        handler = self.class.commands[command]
        if handler.respond_to?(:call)
          handler.call(conn)
        elsif self.class.default_command.respond_to?(:call)
          self.class.default_command.call(conn)
        end
      end

      ::TeBot::Message::GENERAL_MESSAGE_TYPES.each do |f|
        message.public_send(f) do
          handler = self.class.public_send(f)

          next unless handler.respond_to?(:call)
          handler.call(conn)
        end
      end

      if message.handler.respond_to?(:call)
        message.call
      elsif self.class.default_action.respond_to?(:call)
        self.class.default_action.call(conn)
      end
    end
  end
end
