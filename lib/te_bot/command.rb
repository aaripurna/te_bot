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
      @text.scan(/\S+\:\S+/).inject({}) do |memo, query|
        key, value = query.split(':')
        memo[key] = value

        memo
      end
    end
  end
end