# frozen_string_literal: true

require "test_helper"
require "rack/test"
require "json"

class TestGeneralMessage < Minitest::Test
  include Rack::Test::Methods

  Controller = Class.new(::TeBot::Court) do
    command("/start") do |conn, params|
      [200, {"Contet-Type" => "application/json"}, ['{"Hello": "From command /start"}']]
    end

    audio do |conn|
      [200, {"Contet-Type" => "application/json"}, ['{"Hello": "This is audio section"}']]
    end

    voice do |conn|
      [200, {"Contet-Type" => "application/json"}, ['{"Hello": "Hello from voice mail"}']]
    end

    document do |conn|
      [200, {"Contet-Type" => "application/json"}, ['{"Hello": "this is the printer"}']]
    end

    query do |conn|
      [200, {"Contet-Type" => "application/json"}, ['{"Hello": "salam dari mysql"}']]
    end

    text do |conn|
      [200, {"Contet-Type" => "application/json"}, [%({"Hello": "#{conn.message.data.content.parse}"})]]
    end

    default_action do |message|
      [200, {"Contet-Type" => "application/json"}, [%({"Hello": "Tis is the default message"})]]
    end

    default_command do |conn, params|
      [200, {"Contet-Type" => "application/json"}, [%({"Hello": "Sorry, command not found"})]]
    end
  end

  def app
    Controller.new
  end

  def test_command
    response = post("/", JSON.generate({
      "update_id" => 10000,
      "message" => {
        "date" => 1441645532,
        "chat" => {
          "last_name" => "Test Lastname",
          "id" => 1111111,
          "type" => "private",
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "message_id" => 1365,
        "from" => {
          "last_name" => "Test Lastname",
          "id" => 1111111,
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "text" => "/start"
      }
    }), {"CONTENT_TYPE" => "application/json"})

    assert_equal 200, response.status
    assert_equal({"Hello" => "From command /start"}, JSON.parse(response.body))
  end

  def test_audio
    response = post("/", JSON.generate({
      "update_id" => 10000,
      "message" => {
        "date" => 1441645532,
        "chat" => {
          "last_name" => "Test Lastname",
          "type" => "private",
          "id" => 1111111,
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "message_id" => 1365,
        "from" => {
          "last_name" => "Test Lastname",
          "id" => 1111111,
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "audio" => {
          "file_id" => "AwADBAADbXXXXXXXXXXXGBdhD2l6_XX",
          "duration" => 243,
          "mime_type" => "audio/mpeg",
          "file_size" => 3897500,
          "title" => "Test music file"
        }
      }
    }), {"CONTENT_TYPE" => "application/json"})

    assert_equal 200, response.status
    assert_equal({"Hello" => "This is audio section"}, JSON.parse(response.body))
  end

  def test_voice
    response = post("/", JSON.generate({
      "update_id" => 10000,
      "message" => {
        "date" => 1441645532,
        "chat" => {
          "last_name" => "Test Lastname",
          "type" => "private",
          "id" => 1111111,
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "message_id" => 1365,
        "from" => {
          "last_name" => "Test Lastname",
          "id" => 1111111,
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "voice" => {
          "file_id" => "AwADBAADbXXXXXXXXXXXGBdhD2l6_XX",
          "duration" => 5,
          "mime_type" => "audio/ogg",
          "file_size" => 23000
        }
      }
    }), {"CONTENT_TYPE" => "application/json"})

    assert_equal 200, response.status
    assert_equal({"Hello" => "Hello from voice mail"}, JSON.parse(response.body))
  end

  def test_document
    response = post("/", JSON.generate({
      "update_id" => 10000,
      "message" => {
        "date" => 1441645532,
        "chat" => {
          "last_name" => "Test Lastname",
          "type" => "private",
          "id" => 1111111,
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "message_id" => 1365,
        "from" => {
          "last_name" => "Test Lastname",
          "id" => 1111111,
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "document" => {
          "file_id" => "AwADBAADbXXXXXXXXXXXGBdhD2l6_XX",
          "file_name" => "Testfile.pdf",
          "mime_type" => "application/pdf",
          "file_size" => 536392
        }
      }
    }), {"CONTENT_TYPE" => "application/json"})

    assert_equal 200, response.status
    assert_equal({"Hello" => "this is the printer"}, JSON.parse(response.body))
  end

  def test_query
    response = post("/", JSON.generate({
      update_id: 10000,
      inline_query: {
        id: 134567890097,
        from: {
          last_name: "Test Lastname",
          type: "private",
          id: 1111111,
          first_name: "Test Firstname",
          username: "Testusername"
        },
        query: "inline query",
        offset: ""
      }
    }), {"CONTENT_TYPE" => "application/json"})

    assert_equal 200, response.status
    assert_equal({"Hello" => "salam dari mysql"}, JSON.parse(response.body))
  end

  def test_text
    response = post("/", JSON.generate({
      "update_id" => 10000,
      "message" => {
        "date" => 1441645532,
        "chat" => {
          "last_name" => "Test Lastname",
          "id" => 1111111,
          "type" => "private",
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "message_id" => 1365,
        "from" => {
          "last_name" => "Test Lastname",
          "id" => 1111111,
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "text" => "Mantap nggak tuh"
      }
    }), {"CONTENT_TYPE" => "application/json"})

    assert_equal 200, response.status
    assert_equal({"Hello" => "Mantap nggak tuh"}, JSON.parse(response.body))
  end

  def test_default_message
    response = post("/", JSON.generate({"hello" => "World"}), {"CONTENT_TYPE" => "application/json"})

    assert_equal 200, response.status
    assert_equal({"Hello" => "Tis is the default message"}, JSON.parse(response.body))
  end

  def test_default_command
    response = post("/", JSON.generate({
      "update_id" => 10000,
      "message" => {
        "date" => 1441645532,
        "chat" => {
          "last_name" => "Test Lastname",
          "id" => 1111111,
          "type" => "private",
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "message_id" => 1365,
        "from" => {
          "last_name" => "Test Lastname",
          "id" => 1111111,
          "first_name" => "Test Firstname",
          "username" => "Testusername"
        },
        "text" => "/moo"
      }
    }), {"CONTENT_TYPE" => "application/json"})

    assert_equal 200, response.status
    assert_equal({"Hello" => "Sorry, command not found"}, JSON.parse(response.body))
  end
end
