# frozen_string_literal: true

require "rack"
require "json"
require "byebug"

module TeBot
  class Court
    class << self
      attr_reader :wire, :mapper, :default_action, :commands

      def access_token(token)
        @wire = ::TeBot::Wire.new(token)
      end

      def map(text, &block)
        @mapper ||= ::TeBot::Mapper.new
        @mapper.map(text, &block)
      end

      def invalid_command(&block)
        @default_action = block
      end

      def reply(conn, message)
        send_message(chat_id(conn), message)
      end

      def chat_id(conn)
        conn.dig("message", "chat", "id")
      end

      def send_message(chat_id, message)
        wire.send_message(chat_id, message)
      end
      
      def command(text, &block)
        @commands ||= {}
      end
    end

    def call(env)
      json_only(env) do |body|
        command = body.dig("message", "text")
        handler, params = self.class.mapper.call(command)

        if handler.respond_to?(:call)
          handler.call(body, params)
        elsif self.class.default_action.respond_to?(:call)
          self.class.default_action.call(body, params)
        end

        [200, {"Content-Type" => "application/json"}, [JSON.generate({"message" => "success"})]]
      end
    end

    private

    def json_only(env)
      unless env["CONTENT_TYPE"].start_with?("application/json")
        return [400, {"Content-Type" => "application/json"}, [JSON.generate({"message" => "only accepting application/json"})]]
      end

      req = Rack::Request.new(env)
      body = JSON.parse(req.body.read)

      yield(body)
    end

    def handle_request(body)
      message = ::TeBot::Message.new(body)
    end
  end
end
