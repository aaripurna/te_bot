# frozen_string_literal: true

require "faraday"
require "faraday/net_http"

module TeBot
  class Wire
    CONN = Faraday.new(
      url: "https://api.telegram.org/",
      headers: {"Content-Type" => "application/json"}
    )

    def url(path)
      "/bot#{@access_token}/#{path}"
    end

    def initialize(access_token)
      @access_token = access_token
    end

    def send_message(chat_id, message)
      CONN.post(url("sendMessage")) do |req|
        req.params["chat_id"] = chat_id
        req.params["text"] = message
      end
    end
  end
end
