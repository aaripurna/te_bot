# frozen_string_literal: true

require "test_helper"
require "rack/test"
require "json"

class TestCourt < Minitest::Test
  include Rack::Test::Methods

  Controller = Class.new(::TeBot::Court) do
    attr_reader :boo

    map('/start limit:10 not:10') do |params, message|
      params
    end

    map('/boo') do |params, message|
      reply(message)
    end

    def reply(message)
      @boo = :boo
      byebug
    end
  end

  BOO = Class.new(::TeBot::Court) do
    map('/whoami limit:10 not:10') do |params, message|
      params
    end
  end

  def app
    Controller.new
  end

  def test_it_dont_mix
    refute_equal Controller.mapper, BOO.mapper
  end

  def test_it_returns_params
    post '/', JSON.generate({
      "update_id":10000,
      "message":{
        "date":1441645532,
        "chat":{
          "last_name":"Test Lastname",
          "id":1111111,
          "first_name":"Test",
          "username":"Test"
        },
        "message_id":1365,
        "from":{
          "last_name":"Test Lastname",
          "id":1111111,
          "first_name":"Test",
          "username":"Test"
        },
        "text":"/start"
        }})
  end

  def test_it_fallback_to_caller_method
    post '/', JSON.generate({
      "update_id":10000,
      "message":{
        "date":1441645532,
        "chat":{
          "last_name":"Test Lastname",
          "id":1111111,
          "first_name":"Test",
          "username":"Test"
        },
        "message_id":1365,
        "from":{
          "last_name":"Test Lastname",
          "id":1111111,
          "first_name":"Test",
          "username":"Test"
        },
        "text":"/boo"
      }})
  end
end