# frozen_string_literal: true

module TeBot
  module Cable
    def chat_id
      message.data&.chat_id
    end

    def reply(**payload)
      return if chat_id.nil?

      wire.send_message chat_id, **payload
    end
  end
end
