# frozen_string_literal: true

require "rack"
require "json"

module TeBot
  class Court
    def self.inherited(subclass)
      subclass.class_variable_set(:@@mapper, ::TeBot::Mapper.new)
      subclass.class_variable_set(:@@wire, nil)
      subclass.class_variable_set(:@@default_action, nil)

      subclass.class_eval do
        class << self
          def map(text, &block)
            mapper = class_variable_get(:@@mapper)
            mapper.map(text, &block)
            class_variable_set(:@@mapper, mapper)
          end

          def mapper
            class_variable_get(:@@mapper)
          end

          def access_token(token)
            wire = class_variable_get(:@@wire)
            return wire if wire
            class_variable_set(:@@wire, ::TeBot::Wire.new(token))
          end

          def wire
            class_variable_get(:@@wire)
          end

          def invalid_command(&block)
            class_variable_set(:@@default_action, &block)
          end

          def default_action
            class_variable_get(:@@default_action)&.call
          end
        end
      end
    end

    class << self
      def reply(conn, message)
        send_message(chat_id(conn), message)
      end

      def chat_id(conn)
        conn.dig("message", "chat", "id")
      end

      def send_message(chat_id, message)
        wire.send_message(chat_id, message)
      end
    end

    def call(env)
      req = Rack::Request.new(env)
      body = JSON.parse(req.body.read)
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
end
