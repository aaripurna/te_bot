# frozen_string_literal: true

module TeBot
  class Mapper
    def initialize
      @commands = {}
    end

    def map(command, &block)
      @commands[command] = block
      self
    end

    def call(text)
      command, params = ::TeBot::Command.new(text).parse

      handler = @commands[command]

      [handler, params] if handler.respond_to?(:call) && params
    end
  end
end
