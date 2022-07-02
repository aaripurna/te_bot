# frozen_string_literal: true

module TeBot
  class Cable
    attr_reader :message, :params
    def initialize(wire, message, params = {})
      @wire = wire
      @message = message
      @params = params
    end

    def chat_id
      @message.data&.chat_id
    end

    def reply(**payload)
      return if chat_id.nil?

      @wire.send_message chat_id, **payload
    end
  end
end
