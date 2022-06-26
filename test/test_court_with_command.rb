# frozen_string_literal: true

require "test_helper"
require "rack/test"
require "json"

class TestCourtWithCommand < Minitest::Test
  include Rack::Test::Methods

  Controller = Class.new(::TeBot::Court) do
    command("/start") do |_message|
      [200, {"Content-Type" => "text/plain"}, ["Boo"]]
    end

    audio do |params|
      params
    end

    text do |params|
      params
    end

    query do |params|
      params
    end

    document do |params|
      params
    end
  end

  def app
    Controller.new
  end

  def test_command_to_returns_response
    response = post("/", JSON.generate({"message" => {"text" => "/start"}}), {"CONTENT_TYPE" => "application/json"})
    assert_equal 200, response.status
    assert_equal "Boo", response.body
  end

  def test_audio_macro
    assert_equal Controller.audio.call({size: 200, file: "thefile.mp3"}), {size: 200, file: "thefile.mp3"}
  end

  def test_text_macro
    assert_equal Controller.text.call({"message" => {"text" => "Boo"}}), {"message" => {"text" => "Boo"}}
  end

  def test_query_macro
    assert_equal Controller.query.call({"message" => {"query" => "Boo"}}), {"message" => {"query" => "Boo"}}
  end

  def test_document_macro
    assert_equal Controller.document.call({"message" => {"document" => {"file" => "boo.pdf"}}}), {"message" => {"document" => {"file" => "boo.pdf"}}}
  end
end
