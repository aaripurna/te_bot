require_relative "./wire"
require "json"

TeBot::Wire.class_eval do
  sender :text do |chat_id, message|
    make_request("sendMessage", body: {chat_id: chat_id, text: message}.to_json)
  end

  # this is using MarkdownV2 https://core.telegram.org/bots/api#markdownv2-style
  sender :markdown do |chat_id, message|
    make_request("sendMessage", body: {chat_id: chat_id, text: message, parse_mode: "MarkdownV2"}.to_json)
  end

  sender :photo do |chat_id, message|
    make_request("sendPhoto", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :audio do |chat_id, message|
    make_request("sendAudio", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :document do |chat_id, message|
    make_request("sendDocument", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :video do |chat_id, message|
    make_request("sendVideo", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :animation do |chat_id, message|
    make_request("sendAnimation", body: message.merge({chat_id: chat_id}).to_json)
  end

  sender :voice do |chat_id, message|
    make_request("sendVoice", body: message.merge({chat_id: chat_id}).to_json)
  end
end
