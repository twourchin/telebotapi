require 'rubygems'
require 'eventmachine'
require './lib/em-telegram-bot-api.rb'
require 'yaml'

begin
  config = YAML.load_file('config.yml')
  bot = EM::Telegram::Bot.new config["token"]

  EM.run do
    bot.subscribe({:text => ->(text) { text[/^\/start$/]} }) do |msg|
      puts msg.text
    end
    bot.subscribe({:text => ->(text) { text[/^\/help$/]} }) do |msg|
      puts msg.text
      bot.subscribe do |msg|
        puts "NEW SUBSCRIBE: #{msg.text}"
      end
    end
    bot.subscribe do |msg|
      EM.defer do
        sleep 1
        puts msg.text
      end
    end
    bot.get_updates
  end
end
