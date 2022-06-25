# frozen_string_literal: true

require_relative "te_bot/version"

module TeBot
  autoload :Command, "te_bot/command.rb"
  autoload :Mapper, "te_bot/mapper.rb"
  autoload :Court, "te_bot/court.rb"
  autoload :Wire, "te_bot/wire.rb"

  class Error < StandardError; end
  # Your code goes here...
end
