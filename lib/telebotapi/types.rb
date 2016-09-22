class TeleBotApi

  class Type

    @@fields = {}

    def Type.createAccessors(hash)
      hash.each do |k,v|
        self.send(:define_method, k, proc{self.instance_variable_get("@#{k.to_s}")})
        self.send(:define_method, "#{k.to_s}=", proc{|v| self.instance_variable_set("@#{k.to_s}", v)})
      end
    end

    def parseHash(hash)
      hash.each do |k,v|
        case @@fields[k].to_s
        when 'TeleBotApi::User'
          self.instance_variable_set("@#{k.to_s}", User.new(v))
        when 'TeleBotApi::Chat'
          self.instance_variable_set("@#{k.to_s}", Chat.new(v))
        when 'TeleBotApi::Sticker'
          self.instance_variable_set("@#{k.to_s}", Sticker.new(v))
        when 'Fixnum', 'String', 'TrueClass', 'FalseClass'
          self.instance_variable_set("@#{k.to_s}", v)
        else
          self.instance_variable_set("@#{k.to_s}", v)
        end
      end
    end

    def initialize(hash)
      parseHash(hash)
    end
  end

  class User < Type
    attr_accessor :id
    attr_accessor :first_name
    attr_accessor :last_name
    attr_accessor :username

    def initialize(hash)
      [:id, :first_name, :last_name, :username].each do |key|
        if hash.key?(key)
          self.instance_variable_set("@#{key.to_s}", hash[key])
        end
      end
    end
  end

  class Chat < Type
    attr_accessor :id
    attr_accessor :type
    attr_accessor :title
    attr_accessor :username
    attr_accessor :first_name
    attr_accessor :last_name

    def initialize(hash)
      [:id, :type, :title, :username, :first_name, :last_name].each do |key|
        if hash.key?(key)
          self.instance_variable_set("@#{key.to_s}", hash[key])
        end
      end
    end
  end

  class MessageEntity < Type
    def parse(json)
    end
  end

  class Audio < Type
    def parse(json)
    end
  end

  class Video < Type
    def parse(json)
    end
  end

  class PhotoSize < Type
    def parse(json)
    end
  end

  class Sticker < Type
    @@fields = {
        file_id:	String,
        width:	Fixnum,
        height:	Fixnum,
        thumb:	PhotoSize,
        emoji:	String,
        file_size:	Fixnum
    }

  end

  class Voice < Type
    def parse(json)
    end
  end

  class Document < Type
    def parse(json)
    end
  end

  class Contact < Type
    def parse(json)
    end
  end

  class Location < Type
    def parse(json)
    end
  end

  class Venue < Type
    def parse(json)
    end
  end

  class Message < Type

    @@fields = {
      message_id: Fixnum,	#Fixnum
      from: TeleBotApi::User,	#User
      date: Fixnum,	#Fixnum
      chat:	TeleBotApi::Chat,	#Chat
      forward_from: TeleBotApi::User,	#User
      forward_from_chat: TeleBotApi::Chat,	#Chat
      forward_date: Fixnum,	#Fixnum
      reply_to_message: TeleBotApi::Message,	#Message
      edit_date: Fixnum,	#Fixnum
      text: String,	#String
      entities: [TeleBotApi::MessageEntity],	#Array of MessageEntity
      audio: TeleBotApi::Audio,	#Audio
      document: TeleBotApi::Document,	#Document
      photo: [TeleBotApi::PhotoSize],	#Array of PhotoSize
      sticker: TeleBotApi::Sticker,	#Sticker
      video: TeleBotApi::Video,	#Video
      voice: TeleBotApi::Voice,	#Voice
      caption: String,	#String
      contact: TeleBotApi::Contact,	#Contact
      location: TeleBotApi::Location,	#Location
      venue: TeleBotApi::Venue,	#Venue
      new_chat_member: TeleBotApi::User,	#User
      left_chat_member: TeleBotApi::User,	#User
      new_chat_title: String,	#String
      new_chat_photo: [TeleBotApi::PhotoSize],	#Array of PhotoSize
      delete_chat_photo: true,	#true
      group_chat_created: true,	#true
      supergroup_chat_created: true,	#true
      channel_chat_created: true,	#true
      migrate_to_chat_id: Fixnum,	#Fixnum
      migrate_from_chat_id: Fixnum,	#Fixnum
      pinned_message: TeleBotApi::Message	#Message
    }

    createAccessors @@fields

  end

end
