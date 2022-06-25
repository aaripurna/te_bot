# frozen_string_literal: true

require "test_helper"

class TestMapper < Minitest::Test
  def test_it_maps_the_command
    mapper = ::TeBot::Mapper.new

    mapper.map("/start") do |params|
      "This is the start command"
    end

    mapper.map("/query") do |params|
      params
    end

    assert_equal mapper.call("/start limit:10", self), "This is the start command"

    assert_equal mapper.call("/query limit:10 order:DESC", self), {"limit" => "10", "order" => "DESC"}
  end
end
