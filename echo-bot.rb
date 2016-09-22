require './lib/telebotapi.rb'
require 'yaml'

begin
  config = YAML.load_file('config.yml')

  client = TeleBotApi::Client.new(config["token"])
  client.getUpdates do |msg|
    p msg
    message = TeleBotApi::Message.new(msg[:message])
    puts message

    unless message.sticker.nil?
      puts "Get stiker from #{message.from.username}"
      client.sendSticker({
          chat_id:  message.from.id,
          sticker:  message.sticker.file_id
        })
    else
      puts "Get message: \"#{message.text}\" from #{message.from.username}"
      client.sendMessage({
        chat_id:  message.from.id,
        text:     message.text
      })
    end
  end
rescue => exception
  puts exception
end
