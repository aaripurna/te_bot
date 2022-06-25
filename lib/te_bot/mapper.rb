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

    def call(text, opts = nil)
      command, params = ::TeBot::Command.new(text).parse

      handler = @commands[command]

      handler.call(params, opts) if handler.respond_to?(:call)
    end
  end
end
