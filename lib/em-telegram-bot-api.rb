require 'em-http-request'
require 'json'
require 'addressable/uri'
require './lib/telebotapi/types.rb'

module EventMachine

  class Telegram

    class Bot
      TELEGRAMBOTURL = 'https://api.telegram.org/'

      def initialize token
        @subs = {}
        @apiUrl = URI(TELEGRAMBOTURL + 'bot'+ token + '/')
        @update_id = 0
        @uid = 0
      end

      def get_updates
        request_options = {
          :body => { offset: @update_id, timeout: 15 }.to_json,
          :keepalive => true,
          :head => {
            'content-type' => 'application/json',
            'accept' => 'application/json',
            'Accept-Encoding' => 'gzip,deflate,sdch'
          }
        }
        http = EM::HttpRequest.new(@apiUrl + 'getUpdates').post request_options
        http.callback do |response|
          dispatch_updates(response.response)
          get_updates
        end
      end

      def send

      end

      def subscribe hash = {}, &blk
        name = gen_id
        @subs[name] = {rule: hash, block: blk }
        name
      end

      def unsubscribe(name)
        @subs.delete name
      end

      def dispatch_updates response
        hash = JSON.parse(response, :symbolize_names => true)
        if hash.key? :result
          hash[:result].each do |update|
            @update_id = update[:update_id]+1 if update[:update_id] >= @update_id
            message = TeleBotApi::Message.new(update[:message])
            @subs.clone.each do |key, sub|
              if message.hash_match sub[:rule]
                sub[:block].(message)
              end
            end
          end
        end
      end

      private

      def gen_id
        @uid += 1
      end

    end

  end

end
