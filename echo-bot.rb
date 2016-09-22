require './lib/telebotapi.rb'
require 'yaml'

config = YAML.load_file('config.yml')

client = TeleBotApi::Client.new(config["token"])
client.getUpdates do |msg|
  p msg
  client.sendMessage(msg[:message][:chat][:id], msg[:message][:text])
end
