# frozen_string_literal: true

require "test_helper"

class TestCable < Minitest::Test
  ACCESS_TOKEN = "5549790826:OPKJJAx8gNWN7kWt4hUWCrT-_YGk0B35j2A"
  def setup
    stub_request(:post, "https://api.telegram.org/bot#{ACCESS_TOKEN}/sendMessage?chat_id=5093621143&text=This IS Bot")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Length" => "0",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.5.2"
        }
      )
      .to_return(status: 200, body: %(
        {
            "ok": true,
            "result": {
                "message_id": 22,
                "from": {
                    "id": 5549726747,
                    "is_bot": true,
                    "first_name": "NewsNotification_Bot",
                    "username": "nawa_notification_bot"
                },
                "chat": {
                    "id": 5093621143,
                    "first_name": "Nawa",
                    "last_name": "Aripurna",
                    "username": "defmodule",
                    "type": "private"
                },
                "date": 1656089233,
                "text": "This IS Bot"
            }
        }
      ))
  end

  ::TeBot::Wire.class_eval do
    sender :plain_text do |chat_id, message|
      make_request("sendMessage", params: {chat_id: chat_id, text: message})
    end
  end

  Data = Class.new do
    def chat_id
      5093621143
    end
  end

  Message = Class.new do
    def data
      Data.new
    end
  end

  Court = Class.new do
    include ::TeBot::Cable
    attr_reader :wire, :message

    def initialize(wire, message)
      @wire = wire
      @message = message
    end
  end

  def test_reply
    wire = ::TeBot::Wire.new(ACCESS_TOKEN)
    service = Court.new(wire, Message.new)

    response = service.reply plain_text: "This IS Bot"

    assert_equal 200, response.status
    assert_equal "This IS Bot", JSON.parse(response.body).dig("result", "text")
  end
end
