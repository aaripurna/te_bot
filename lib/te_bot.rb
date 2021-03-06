# frozen_string_literal: true

require_relative "te_bot/version"

module TeBot
  autoload :Court, "te_bot/court.rb"
  autoload :Wire, "te_bot/wire.rb"
  autoload :Message, "te_bot/message.rb"
  autoload :Cable, "te_bot/cable.rb"

  class Error < StandardError; end
  # Your code goes here...
end
