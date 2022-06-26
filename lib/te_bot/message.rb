# frozen_string_literal: true

module TeBot
  class Message
    def initialize(body)
      data = body.dig("message") || body.dig("edit_date") ||
        body.dig("inline_query") || body.dig("chosen_inline_result") ||
        body.dig("chosen_inline_result")

      @message = Format.new(data)
    end

    def data
      @message
    end

    %I[command text query document audio voice].each do |format|
      define_method(format) do |&block|
        instance_variable_set("@#{format}", block)
      end
    end

    def call
      return unless data || data.content
      content_class = data.content.class.name.split("::").last.downcase

      return unless instance_variable_get("@#{content_class}")

      instance_variable_get("@#{content_class}").call
    end

    class Format
      attr_reader :date, :chat, :message_id, :from, :forward_from,
        :forward_date, :reply_to_message, :content, :edit_date, :chat_id

      def initialize(message = {})
        @date = message.dig("date")
        @chat = message.dig("chat")
        @message_id = message.dig("message_id")
        @from = message.dig("from")
        @forward_from = message.dig("forward_from")
        @forward_date = message.dig("forward_date")
        @edit_date = message.dig("edit_date")
        @content = extract_content(message)
        @chat_id = @chat&.dig("id")

        @reply_to_message = message.dig("reply_to_message")
      end

      private

      def extract_content(message = {})
        if message.dig("audio")
          return Audio.new(message)
        elsif message.dig("voice")
          return Voice.new(message)
        elsif message.dig("document")
          return Document.new(message)
        elsif message.dig("query") || message.dig("data")
          return Query.new(message)
        end

        text = message.dig("text")
        return unless text

        if /^\/\S+/.match?(text)
          Command.new(message)
        else
          Text.new(message)
        end
      end

      def extract_reply(message = {})
        return unless message.dig("reply_to_message")

        Format.new(message.dig("reply_to_message"))
      end
    end

    class Command
      def initialize(message)
        @text = message.dig("text")
      end

      def parse
        command
      end

      private

      def command
        @command ||= [extract_command, extract_params]
      end

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

    class Text
      def initialize(message)
        @text = message.dig("text")
      end

      def parse
        @text
      end
    end

    class Query
      def initialize(message)
        @query = message.dig("query") || message.dig("data")
      end

      def parse
        @query
      end
    end

    class Document
      def initialize(message)
        @document = message.dig("document")
      end

      def parse
        @document
      end
    end

    class Audio
      def initialize(message)
        @audio = message.dig("audio")
      end

      def parse
        @audio
      end
    end

    class Voice
      def initialize(message)
        @voice = message.dig("voice")
      end

      def parse
        @voice
      end
    end
  end
end
