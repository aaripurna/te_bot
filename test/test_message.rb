# frozen_string_literal: true

require "test_helper"

class TestMessage < Minitest::Test
  def test_audio_message
    message = ::TeBot::Message.new({
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
    })

    assert_instance_of ::TeBot::Message::Audio, message.data.content

    message.audio do
      10
    end

    assert_equal 10, message.call
  end

  def test_voice_message
    message = ::TeBot::Message.new({
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
    })

    assert_instance_of ::TeBot::Message::Voice, message.data.content

    message.voice do
      30
    end
    assert_equal 30, message.call
  end

  def test_document_message
    message = ::TeBot::Message.new({
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
    })

    assert_instance_of ::TeBot::Message::Document, message.data.content

    message.document do
      "Document"
    end

    assert_equal "Document", message.call
  end

  def test_text_message
    message = ::TeBot::Message.new({
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
        "text" => "Bold and italics",
        "entities" => [
          {
            "type" => "italic",
            "offset" => 9,
            "length" => 7
          },
          {
            "type" => "bold",
            "offset" => 0,
            "length" => 4
          }
        ]
      }
    })

    assert_instance_of ::TeBot::Message::Text, message.data.content

    message.text do
      "Boo"
    end

    assert_equal "Boo", message.call
  end

  def test_command_message
    message = ::TeBot::Message.new({
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
    })

    assert_instance_of ::TeBot::Message::Command, message.data.content

    message.command do
      "command"
    end

    assert_equal "command", message.call
  end
end
