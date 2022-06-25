# frozen_string_literal: true

require "test_helper"

class TestMapper < Minitest::Test
  def test_it_maps_the_command
    mapper = ::TeBot::Mapper.new

    mapper.map("/start") do |conn, params|
      "This is the start command"
    end

    mapper.map("/query") do |conn, params|
      params
    end

    assert_equal mapper.call("/start limit:10")[0].call(nil, nil), "This is the start command"

    block, params = mapper.call("/query limit:10 order:DESC")
    assert_equal block.call(nil, params), {"limit" => "10", "order" => "DESC"}
  end
end
