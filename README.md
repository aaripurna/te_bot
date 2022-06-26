# ::TeBot

[![Gem Version](https://badge.fury.io/rb/te_bot.svg)](https://badge.fury.io/rb/te_bot) ![Main Workflows](https://github.com/aaripurna/te_bot/actions/workflows/main.yml/badge.svg)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/te_bot`. To experiment with that code, run `bin/console` for an interactive prompt.

This gem is used to handle telegram webhook and sending message with telegram bot

## Installation

Install the gem and add to the application's Gemfile

    gem 'te_bot', '~> 0.1.0'

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

class MyWebhookApp < TeBot::Court
  access_token ENV["YOUR_BOT_ACCESS_TOKEN"]
    
  command("/start") do |conn, params|
    reply(conn, "Welcome aboard my friend!")
  end
    
  command("/today") do |conn, params|
    reply(conn, Time.now.to_s)
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
The command aslo support argument that will be passed to the `#command` block as `params`. To pass arguments, we can simply type `/today city:Jakarta limit:10`. The argument will be parsed as a Hash with string key => `{"city" => "Jakarta", "limit" => "10"}`. While the parameter `conn` is the message object which contains the full message including the chat_id to repy to.

To add a default handler for non existing command we can use the `#default_command` macro.

```rb
# app.rb

class MyWebhookApp < TeBot::Court
  default_command do |conn, params|
    reply(conn, "Sorry, Comand not found. Try another command. or type /help")
  end
end
```

Other type of messages are also supported by using this macros `text` for regular text message, `query`, `document`, `audio`, and `voice`. For more detail please check this [Telegram Docs](https://core.telegram.org/bots/webhooks#testing-your-bot-with-updates). These macros is only expecting `conn` as an argument.

```rb
# app.rb

class MyWebhookApp < TeBot::Court
  text do |conn|
    message = do_some_fancy_stuff_here(conn)
    reply(conn, message)
  end
end
```
And also we can define a macro for defaul action `#default_action` if the request does not match with this [Documentation](https://core.telegram.org/bots/webhooks#testing-your-bot-with-updates), Or we have not create the handler for that specific message type. Just becarefull, the `conn.data` might returns nil if the message format doesnot match the documentation.

```rb
# app.rb

class MyWebhookApp < TeBot::Court
  default_action do |conn|
    reply(conn, "No, I can't talk like people. use command instead") if conn.data&.chat_id
  end
end
```
Since this app implements rack interface, and railr is also a rack based application. We can mount this app direcly inside rails app.

```rb
# config/routes.rb

require "lib/to/your_webhook"

Rails.application.routes.draw do
  mount MyAwessomWebhook.new => "telegram_webhook"
end
```

### Sending Message to Telegram
To send message direcly to telegram, we can use this module `TeBot::Wire`

```rb
# app.rb
sender = TeBot::Wire.new(ENV['YOUR_ACCESS_TOKEN_HERE'])
sender.send_message(chat_id, message_string)
```
This gem only support [sendMessage](https://core.telegram.org/bots/api#sendmessage) API for this moment.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aaripurna/te_bot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/aaripurna/te_bot/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the TeBot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aaripurna/te_bot/blob/main/CODE_OF_CONDUCT.md).
