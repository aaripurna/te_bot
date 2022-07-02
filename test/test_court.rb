# frozen_string_literal: true

require "test_helper"
require "rack/test"
require "json"

class TestCourt < Minitest::Test
  include Rack::Test::Methods

  ::TeBot::Wire.class_eval do
    sender :plain do |conn, chat_id, message|
      conn.make_request("sendMessage", params: {chat_id: chat_id, text: message})
    end
  end

  def setup
    stub_request(:post, "https://api.telegram.org/bot5549790826:OPKJJAx8gNWN7kWt4hUWCrT-_YGk0B35j2A/sendMessage?chat_id=5093621143&text=This IS Bot")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Length" => "0",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.3.0"
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

  Controller = Class.new(::TeBot::Court) do
    access_token "5549790826:OPKJJAx8gNWN7kWt4hUWCrT-_YGk0B35j2A"
    attr_reader :boo

    command("/start") do |conn|
      [200, {"Content-Type" => "json"}, [JSON.generate(conn.params)]]
    end

    command("/boo") do |conn|
      talk_back(conn)
    end

    command("/foo") do |conn|
      conn.reply plain: "This IS Bot"
    end

    class << self
      def talk_back(message)
        @boo = :boo
      end
    end
  end

  BOO = Class.new(::TeBot::Court) do
    command("/whoami limit:10 not:10") do |params, message|
      params
    end
  end

  def app
    Controller.new
  end

  def test_it_dont_mix
    refute_equal Controller.commands, BOO.commands
  end

  def test_it_returns_params
    response = post "/", JSON.generate({
      update_id: 10000,
      message: {
        date: 1441645532,
        chat: {
          last_name: "Test Lastname",
          id: 1111111,
          first_name: "Test",
          username: "Test"
        },
        message_id: 1365,
        from: {
          last_name: "Test Lastname",
          id: 1111111,
          first_name: "Test",
          username: "Test"
        },
        text: "/start limit:20 order:desc"
      }
    }), {"CONTENT_TYPE" => "application/json"}

    assert_equal response.status, 200
    assert_equal({"limit" => "20", "order" => "desc"}, JSON.parse(response.body))
  end

  def test_it_fallback_to_caller_method
    response = post "/", JSON.generate({
      update_id: 10000,
      message: {
        date: 1441645532,
        chat: {
          last_name: "Test Lastname",
          id: 1111111,
          first_name: "Test",
          username: "Test"
        },
        message_id: 1365,
        from: {
          last_name: "Test Lastname",
          id: 1111111,
          first_name: "Test",
          username: "Test"
        },
        text: "/boo"
      }
    }), {"CONTENT_TYPE" => "application/json"}

    assert_equal response.status, 200
  end

  def test_it_can_send_message
    response = post "/", JSON.generate({
      update_id: 10000,
      message: {
        date: 1441645532,
        chat: {
          last_name: "Test Lastname",
          id: 5093621143,
          first_name: "Test",
          username: "Test"
        },
        message_id: 1365,
        from: {
          last_name: "Test Lastname",
          id: 5093621143,
          first_name: "Test",
          username: "Test"
        },
        text: "/foo"
      }
    }), {"CONTENT_TYPE" => "application/json"}

    assert_equal response.status, 200
  end
end
