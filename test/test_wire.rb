# frozen_string_literal: true

require "test_helper"

class TestWire < Minitest::Test
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
    sender :boo, :foo

    def foo(chat_id, message)
      make_request("sendMessage", params: {chat_id: chat_id, text: message})
    end
  end

  def test_sender_handler_string
    service = ::TeBot::Wire.new(ACCESS_TOKEN)
    response = service.send_message(5093621143, boo: "This IS Bot")
    assert_equal response.status, 200

    assert_equal response.body, %(
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
      )
  end

  ::TeBot::Wire.class_eval do
    sender :foo do |chat_id, message|
      make_request("sendMessage", params: {chat_id: chat_id, text: message})
    end
  end

  def test_sender_handler_block
    service = ::TeBot::Wire.new(ACCESS_TOKEN)
    response = service.send_message(5093621143, foo: "This IS Bot")

    assert_equal response.status, 200
    assert_equal response.body, %(
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
      )
  end
end
