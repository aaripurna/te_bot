# frozen_string_literal: true

module TeBot
  class Command
    def initialize(text)
      @text = text
    end

    def parse
      [extract_command, extract_params]
    end

    private

    def extract_command
      r = @text.match(/^\/\S+/)

      r[0] if r
    end

    def extract_params
      @text.scan(/\S+:\S+/).each_with_object({}) do |query, memo|
        key, value = query.split(":")
        memo[key] = value
      end
    end
  end
end
