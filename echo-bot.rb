require './lib/telebotapi.rb'
require 'yaml'

begin
  config = YAML.load_file('config.yml')

  client = TeleBotApi::Client.new(config["token"])
  client.getUpdates do |msg|
    message = TeleBotApi::Message.new(msg[:message])
    response = {
      chat_id:  message.from.id
    }
    method = 'sendMessage'
    if !message.sticker.nil?
      puts "Get stiker from #{message.from.username}"
      response[:sticker] = message.sticker.file_id
      method = 'sendSticker'
    elsif !message.photo.nil?
      puts "Get photo from #{message.from.username}"
      response[:photo] = message.photo[0].file_id
      response[:caption] = message.caption unless message.caption.nil?
      method = 'sendPhoto'
    elsif !message.video.nil?
      puts "Get video from #{message.from.username}"
      response[:video] = message.video.file_id
      response[:caption] = message.caption unless message.caption.nil?
      method = 'sendVideo'
    elsif !message.document.nil?
      puts "Get document from #{message.from.username}"
      response[:document] = message.document.file_id
      response[:file_name] = message.document.file_name unless message.document.file_name.nil?
      method = 'sendDocument'
    else
      puts "Get message: \"#{message.text}\" from #{message.from.username}"
      response[:text] = message.text
    end
    client.sendMethod(method, response)
  end
rescue SystemExit, Interrupt
  # raise
rescue Exception => e
  raise
end
