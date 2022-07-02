# frozen_string_literal: true

require "faraday"
require "faraday/net_http"

module TeBot
  class Wire
    class << self
      def sender(message_format, handler = nil, &block)
        @senders ||= {}
        @senders[message_format] = (block || handler)
      end

      def senders
        @senders || {}
      end
    end

    CONN = Faraday.new(
      url: "https://api.telegram.org/",
      headers: {"Content-Type" => "application/json"}
    )

    def initialize(access_token)
      @access_token = access_token
    end

    def make_request(path, params: nil, headers: nil, body: nil)
      CONN.post(url(path)) do |req|
        req.params.merge!(params) if params
        req.headers.merge!(headers) if headers
        req.body = body if body
      end
    end

    def url(path)
      "/bot#{@access_token}/#{path}"
    end

    def send_message(chat_id, **payload)
      message_format, message = payload.first
      handler = self.class.senders[message_format]

      raise ArgumentError, "Message type invalid. sender :#{message_format} not defined" if handler.nil?

      return handler.call(self, chat_id, message) if handler.respond_to?(:call)

      public_send(handler, chat_id, message)
    end
  end
end
