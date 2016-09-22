require 'net/http'
require 'json'

class TeleBotApi
  TELEGRAMBOTURL = 'https://api.telegram.org/'

  class Client

    attr_accessor :update_id

    def initialize(token)
      @apiUrl = URI(TELEGRAMBOTURL + 'bot'+ token + '/')
      @update_id = 0
    end

    def getMe()
      response = httpSend('getMe', '')
      return response
    end

    def sendMessage(chat, text)
      response = httpSend('sendMessage', { chat_id: chat, text: text }.to_json)
    end

    def getUpdates(timeout=60)
      if block_given?
        loop do
          ok, messages = getUpdate({ offset: @update_id, timeout: timeout }.to_json)
          if ok
            messages.each do |message|
              @update_id = message[:update_id]+1 if message[:update_id] >= @update_id
              yield message
            end
          else
            break
          end
        end
      else
        ok, messages = getUpdate({ offset: @update_id }.to_json)
        return messages
      end
    end

    private

    def getUpdate(data)
      begin
        response = httpSend('getUpdates', data)
        # TEST for HTTP 200
        if response.is_a?(Net::HTTPSuccess)
          return true, responseHandler(response.body)
        else
          return false
        end
      rescue
        return false
      end
    end

    def responseHandler(body)
      hash_response = JSON.parse(body, :symbolize_names => true)
      return hash_response[:result]
    end

    def httpSend(aMethod, aJson)
      if @httpSender.nil?
        @httpSender = Net::HTTP.new(@apiUrl.host, @apiUrl.port)
        @httpSender.use_ssl=true
        # @httpSender.set_debug_output $stderr
      end

      begin
        response = @httpSender.request_post(@apiUrl.request_uri + aMethod, aJson, { "content-type" => "application/json", "Connection" => "keep-alive" })
      rescue
        p response
      end

      return response
    end
  end

  # class User
  #
  #   def User.parse(json)
  #
  #   end
  #
  # end
  #
  # class Chat
  #
  # end
  #
  # class Message
  #
  # end
  #

  # class MessageEntity
  #
  # end

end
