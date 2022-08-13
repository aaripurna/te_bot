# frozen_string_literal: true

require "test_helper"
require "te_bot/sender_options"
require "json"

class TestSenderOptions < Minitest::Test
  ACCESS_TOKEN = "5549790826:OPKJJAx8gNWN7kWt4hUWCrT-_YGk0B35j2A"

  def test_send_text
    stub_request(:post, "https://api.telegram.org/bot#{ACCESS_TOKEN}/sendMessage")
      .with(
        body: JSON.generate({chat_id: 5093621143, text: "This IS Bot"}),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.5.2"
        }
      )
      .to_return(status: 200, body: "")

    service = ::TeBot::Wire.new(ACCESS_TOKEN)
    response = service.send_message(5093621143, text: "This IS Bot")

    assert 200, response.status
  end

  def test_send_markdown
    text = <<~MARKDOWN
      *The Title*
      __underline__
    MARKDOWN

    stub_request(:post, "https://api.telegram.org/bot#{ACCESS_TOKEN}/sendMessage")
      .with(
        body: JSON.generate({chat_id: 5093621143, text: text, parse_mode: "MarkdownV2"}),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.5.2"
        }
      )
      .to_return(status: 200, body: "")
    service = ::TeBot::Wire.new(ACCESS_TOKEN)

    response = service.send_message(5093621143, markdown: text)
    assert 200, response.status
  end

  def test_send_photo
    stub_request(:post, "https://api.telegram.org/bot#{ACCESS_TOKEN}/sendPhoto")
      .with(
        body: JSON.generate({photo: "https://robohash.org/exvoluptasblanditiis.png?size=300x300&set=set1", caption: "This is photo", chat_id: 5093621143}),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.5.2"
        }
      )
      .to_return(status: 200, body: "")

    service = ::TeBot::Wire.new(ACCESS_TOKEN)
    response = service.send_message(5093621143, photo: {photo: "https://robohash.org/exvoluptasblanditiis.png?size=300x300&set=set1", caption: "This is photo"})

    assert 200, response.status
  end

  def test_send_audio
    stub_request(:post, "https://api.telegram.org/bot#{ACCESS_TOKEN}/sendAudio")
      .with(
        body: JSON.generate({audio: "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3", caption: "This is audio", chat_id: 5093621143}),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.5.2"
        }
      )
      .to_return(status: 200, body: "")

    service = ::TeBot::Wire.new(ACCESS_TOKEN)

    response = service.send_message(5093621143, audio: {audio: "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3", caption: "This is audio"})

    assert 200, response.status
  end

  def test_send_document
    stub_request(:post, "https://api.telegram.org/bot#{ACCESS_TOKEN}/sendDocument")
      .with(
        body: JSON.generate({document: "https://file-examples.com/wp-content/uploads/2017/10/file-sample_150kB.pdf", caption: "This is document", chat_id: 5093621143}),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.5.2"
        }
      )
      .to_return(status: 200, body: "")

    service = ::TeBot::Wire.new(ACCESS_TOKEN)

    response = service.send_message(5093621143, document: {document: "https://file-examples.com/wp-content/uploads/2017/10/file-sample_150kB.pdf", caption: "This is document"})

    assert 200, response.status
  end

  def test_send_video
    stub_request(:post, "https://api.telegram.org/bot#{ACCESS_TOKEN}/sendVideo")
      .with(
        body: JSON.generate({video: "https://file-examples.com/storage/feb44f19e262bf9eaa3135a/2017/04/file_example_MP4_480_1_5MG.mp4", caption: "This is video", chat_id: 5093621143}),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.5.2"
        }
      )
      .to_return(status: 200, body: "")

    service = ::TeBot::Wire.new(ACCESS_TOKEN)

    response = service.send_message(5093621143, video: {video: "https://file-examples.com/storage/feb44f19e262bf9eaa3135a/2017/04/file_example_MP4_480_1_5MG.mp4", caption: "This is video"})

    assert 200, response.status
  end

  def test_send_animation
    stub_request(:post, "https://api.telegram.org/bot#{ACCESS_TOKEN}/sendAnimation")
      .with(
        body: JSON.generate({animation: "https://media.giphy.com/media/7kn27lnYSAE9O/giphy.gif", caption: "This is animation", chat_id: 5093621143}),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.5.2"
        }
      )
      .to_return(status: 200, body: "")

    service = ::TeBot::Wire.new(ACCESS_TOKEN)

    response = service.send_message(5093621143, animation: {animation: "https://media.giphy.com/media/7kn27lnYSAE9O/giphy.gif", caption: "This is animation"})

    assert 200, response.status
  end

  def test_send_voice
    stub_request(:post, "https://api.telegram.org/bot#{ACCESS_TOKEN}/sendVoice")
      .with(
        body: JSON.generate({voice: "https://file-examples.com/storage/feb44f19e262bf9eaa3135a/2017/11/file_example_OOG_1MG.ogg", caption: "This is voice", chat_id: 5093621143}),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "User-Agent" => "Faraday v2.5.2"
        }
      )
      .to_return(status: 200, body: "")

    service = ::TeBot::Wire.new(ACCESS_TOKEN)

    response = service.send_message(5093621143, voice: {voice: "https://file-examples.com/storage/feb44f19e262bf9eaa3135a/2017/11/file_example_OOG_1MG.ogg", caption: "This is voice"})

    assert 200, response.status
  end
end
