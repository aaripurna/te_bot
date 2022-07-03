# ::TeBot

[![Gem Version](https://badge.fury.io/rb/te_bot.svg)](https://badge.fury.io/rb/te_bot) ![Main Workflows](https://github.com/aaripurna/te_bot/actions/workflows/main.yml/badge.svg)

Welcome to yet another telegram bot webhook handler.

This gem is used to handle telegram webhook and sending message with telegram bot.

## Installation

Install the gem and add to the application's Gemfile

    gem 'te_bot'

Then run

    bundle install    

If bundler is not being used to manage dependencies, install the gem by executing:

    gem install te_bot

## Usage

### Webhook
This gem can be used as a standalone app since it implement rack interface. To use it as a standalone app, you need to define the webhook 
```rb
# app.rb

require "te_bot"
require "te_bot/sender_options"

class MyWebhookApp < TeBot::Court
  access_token ENV["YOUR_BOT_ACCESS_TOKEN"]
    
  command("/start") do |conn|
    conn.reply text: "Welcome aboard my friend!"
  end
    
  command("/today") do |conn|
    conn.reply text: Time.now.to_s
  end
end
```

To run this as a standalone app, you need to install `rack` and a webserver such as `puma`

    bundle add rack puma

create a file named `config.ru` as the rack entrypoint.

```rb
# config.ru

require_relative "./app"

run MyWebhookApp.new
```
To run the app we can use rackup

    bundle exec rackup

For more detailed information about rack please visit [Rack Repository](https://github.com/rack/rack).

Now, our `MyWebhookApp` class is ready to handle some commands from telegram bot which are `/start` and `/today`.
The command aslo support argument that will be passed to the `#command` block as `conn.params`. To pass arguments, we can simply type `/today city:Jakarta limit:10`. The argument will be parsed as a Hash with string key => `{"city" => "Jakarta", "limit" => "10"}`. While the parameter `conn` is the message object which contains the full message including the chat_id to repy to.

To add a default handler for non existing command we can use the `#default_command` macro.

```rb
# app.rb

class MyWebhookApp < TeBot::Court
  default_command do |conn|
    conn.reply text: "Sorry, Comand not found. Try another command. or type /help"
  end
end
```

Other type of messages are also supported by using this macros `text` for regular text message, `query`, `document`, `audio`, and `voice`. For more detail please check this [Telegram Docs](https://core.telegram.org/bots/webhooks#testing-your-bot-with-updates). These macros is only expecting `conn` as an argument.

```rb
# app.rb

class MyWebhookApp < TeBot::Court
  text do |conn|
    message = do_some_fancy_stuff_here(conn)
    conn.reply text: message
  end
end
```
And also we can define a macro for default action `#default_action` if the request does not match with this [Documentation](https://core.telegram.org/bots/webhooks#testing-your-bot-with-updates), Or we have not created the handler for that specific message type.

```rb
# app.rb

class MyWebhookApp < TeBot::Court
  default_action do |conn|
    conn.reply text: "No, I can't talk like people. use command instead"
  end
end
```
Since this app implements rack interface, and rails is also a rack based application. We can mount this app direcly inside rails app.

```rb
# config/routes.rb

require "lib/to/your_webhook"

Rails.application.routes.draw do
  mount MyAwessomWebhook.new => "telegram_webhook"
end
```

### Sending Message to Telegram
To send message direcly to telegram, we can use this module `TeBot::Wire`
and need to require `"te_bot/sender_options"` to add default handler for different type of messages.
Available message types are `:text`, `:markdown`, `:photo`, `:audio`, `:document`, `:video`, `:animation` amd `:voice`

Some supported message by default:
```rb
# app.rb
sender = TeBot::Wire.new(ENV['YOUR_ACCESS_TOKEN_HERE'])
sender.send_message(chat_id, text: message_string)
sender.send_message(chat_id, markdown: markdown_string)

sender.send_message(chat_id, photo: { photo: url, caption: caption })
sender.send_message(chat_id, video: { video: url, caption: caption})
sender.send_message(chat_id, document: { document: url, caption: caption})
sender.send_message(chat_id, audio: { audio: url, caption: caption})
sender.send_message(chat_id, animation: { animation: url, caption: caption})

```

For markdown telegram supports MarkdownV2 [refer to this](https://core.telegram.org/bots/api#markdownv2-style)
Please check the [documentation](https://core.telegram.org/bots/api#sendmessage) for more details.

### Custom Handler

Of course you can add more handler by extending the `TeBot::Wire` class

```ruby
# in/your/custom_handler.rb

TeBot::Wire.class_eval do
  sender :json do |conn, chat_id, message|
    conn.make_request("sendMessage", body: { chat_id: chat_id, json: message }.to_json)
  end
end
```

### Helpers
If you want to add a complex logic, you can make it into a separate methods by defining class methods or using the `helpers` macro.
You can also create a module then extend it in your main class

Using module
```ruby
# request_helpers.rb

module RequestHelpers
  def get_nearest_hospitals(conn)
    # do some fancy stuff
  end

  def get_the_nearest_routes(hospitals)
    # do some even fancier stuff
  end 

  def render_markdown(routes)
    # do something else
  end
end

class MyWebhookApp < TeBot::Court
  extend RequestHelpers

  #... the rest of the code
end

```

Using helpers macro
```ruby

# app.rb

class MyWebhookApp < TeBot::Court
  command("/findhospital") do |conn|
    hospitals = get_nearest_hospitals(conn)
    routes = get_the_nearest_routes(hospitals)

    conn.reply markdown: render_markdown(routes)
  end

  helpers do
    def get_nearest_hospitals(conn)
      # do some fancy stuff
    end

    def get_the_nearest_routes(hospitals)
      # do some even fancier stuff
    end 

    def render_markdown(routes)
      # do something else
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aaripurna/te_bot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/aaripurna/te_bot/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the TeBot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aaripurna/te_bot/blob/main/CODE_OF_CONDUCT.md).
