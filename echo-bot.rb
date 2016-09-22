require './lib/telebotapi.rb'
require 'yaml'

begin
  config = YAML.load_file('config.yml')

  client = TeleBotApi::Client.new(config["token"])
  client.getUpdates do |msg|
    # p msg
    p TeleBotApi::Message.new(msg[:message])
    client.sendMessage(msg[:message][:chat][:id], msg[:message][:text],msg[:message][:message_id])
  end
rescue

end
