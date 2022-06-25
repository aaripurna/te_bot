# frozen_string_literal: true
require 'rack'
require 'json'

module TeBot
  class Court
    def self.inherited(subclass)
      subclass.class_variable_set(:@@mapper, ::TeBot::Mapper.new)

      subclass.class_eval do
        class << self
          attr_accessor :mapper

          def map(text, &block)
            mapper = class_variable_get(:@@mapper)
            mapper.map(text, &block)
            class_variable_set(:@@mapper, mapper)
          end

          def mapper
            class_variable_get(:@@mapper)
          end

          def access_token(token)
            define_method(:access_token) { token }
          end
        end
      end
    end

    def call(env)
      req = Rack::Request.new(env)
      body = JSON.parse(req.body.read)
      command = body.dig('message', 'text')
      begin
        self.class.mapper.call(command, body)
      rescue NoMethodError => e
        self.send(e.name, *e.args)
      end

      [200, { 'Content-Type' => 'application/json'}, [JSON.generate({'message' => 'success'})]]
    end

    def chat_id(conn)
      conn.dig('message', 'chat', 'id')
    end

    def send_message(chat_id, message)
      
    end
  end
end
