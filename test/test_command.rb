# frozen_string_literal: true

require "test_helper"

class TestCommand < Minitest::Test
  def test_it_parses_the_command
    command, _ = ::TeBot::Message::Command.new({"text" => "/start"}).parse

    assert_equal command, "/start"
  end

  def test_it_extreact_the_options
    _, params = ::TeBot::Message::Command.new({"text" => "/start limit:10 place:table"}).parse
    assert_equal params, {"limit" => "10", "place" => "table"}
  end
end
