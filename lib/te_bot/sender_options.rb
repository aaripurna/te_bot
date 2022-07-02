require_relative "./wire"
require "json"

TeBot::Wire.class_eval do
  sender :text do |conn, chat_id, message|
    conn.make_request("sendMessage", body: {chat_id: chat_id, text: message}.to_json)
  end

  # this is using MarkdownV2 https://core.telegram.org/bots/api#markdownv2-style
  sender :markdown do |conn, chat_id, message|
    conn.make_request("sendMessage", body: {chat_id: chat_id, text: message, parse_mode: "MarkdownV2"}.to_json)
  end

  sender :photo do |conn, chat_id, message|
    conn.make_request("sendPhoto", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :audio do |conn, chat_id, message|
    conn.make_request("sendAudio", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :document do |conn, chat_id, message|
    conn.make_request("sendDocument", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :video do |conn, chat_id, message|
    conn.make_request("sendVideo", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :animation do |conn, chat_id, message|
    conn.make_request("sendAnimation", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :voice do |conn, chat_id, message|
    conn.make_request("sendVoice", body: message.merge({chat_id: chat_id}).to_json)
  end
end
