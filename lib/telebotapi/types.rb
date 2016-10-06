class TeleBotApi

  class Type

    def Type.hash_accessors(hash)
      self.send(:define_method, 'api_fields', proc{ hash })
      hash.each do |k,v|
        self.send(:define_method, k, proc{ self.instance_variable_get("@#{k}") })
        self.send(:define_method, "#{k}=", proc{ |v| self.instance_variable_set("@#{k}", v) })
      end
    end

    def parse_hash(hash)
      hash.each do |k,v|
        case api_fields[k].to_s
        when 'Fixnum', 'String', 'TrueClass', 'FalseClass', 'Float'
          self.instance_variable_set("@#{k}", v)
        else
          if api_fields[k].instance_of?(Array)
            array = []
            v.each do |value|
              array.push api_fields[k][0].new(value)
            end
            self.instance_variable_set("@#{k}", array)
          else
            self.instance_variable_set("@#{k}", api_fields[k].new(v))
          end
        end
      end
    end

    def initialize(hash)
      parse_hash(hash)
    end

    def hash_match(hash)
      is_match = true
      hash.each do |key, value|
        if self.respond_to? "#{key}"
          inst_value = self.instance_variable_get "@#{key}"
          if inst_value.respond_to? 'hash_match'
            is_match = is_match && inst_value.hash_match(value)
          else
            if value.instance_of? Proc
              is_match = is_match && (value.call(inst_value))
            else
              is_match = is_match && (inst_value == value)
            end
          end
        else
          is_match = false
        end
        break unless is_match
      end
      is_match
    end

  end

  class User < Type
    hash_accessors ({
      id:	Fixnum,
      first_name:	String,
      last_name:	String,
      username:	String
    })
  end

  class Chat < Type
    hash_accessors ({
      id:	Fixnum,
      type:	String,
      title:	String,
      username:	String,
      first_name:	String,
      last_name:	String
    })
  end

  class MessageEntity < Type
    hash_accessors ({
      type:	String,
      offset:	Fixnum,
      length:	Fixnum,
      url:	String,
      user:	TeleBotApi::User,
      last_name:	String
    })
  end

  class Audio < Type
    hash_accessors ({
      file_id:	String,
      duration:	Fixnum,
      performer:	String,
      title:	String,
      mime_type:	String,
      file_size:	Fixnum
    })
  end

  class PhotoSize < Type
    hash_accessors ({
      file_id:	String,
      width:	Fixnum,
      height:	Fixnum,
      file_size:	Fixnum,
      file_path: String
    })
  end

  class Video < Type
    hash_accessors ({
      file_id:	String,
      width:	Fixnum,
      height:	Fixnum,
      duration:	Fixnum,
      thumb:	TeleBotApi::PhotoSize,
      mime_type:	String,
      file_size:	Fixnum
    })
  end

  class Sticker < Type
    hash_accessors ({
        file_id:	String,
        width:	Fixnum,
        height:	Fixnum,
        thumb:	PhotoSize,
        emoji:	String,
        file_size:	Fixnum
    })
  end

  class Voice < Type
    hash_accessors ({
      file_id:	String,
      duration:	Fixnum,
      mime_type:	String,
      file_size:	Fixnum
    })
  end

  class Document < Type
    hash_accessors ({
      file_id:	String,
      thumb:	TeleBotApi::PhotoSize,
      file_name:	String,
      mime_type:	String,
      file_size:	Fixnum,
    })
  end

  class Voice < Type
    hash_accessors ({
      file_id:	String,
      duration:	Fixnum,
      mime_type:	String,
      file_size:	Fixnum
    })
  end

  class Contact < Type
    hash_accessors ({
      phone_number:	String,
      first_name:	String,
      last_name:	String,
      user_id:	Fixnum
    })
  end

  class Location < Type
    hash_accessors ({
      longitude:	Float,
      latitude:	Float
    })
  end

  class Venue < Type
    hash_accessors ({
      location:	TeleBotApi::Location,
      title:	String,
      address:	String,
      foursquare_id:	String
    })
  end

  class File < Type
    hash_accessors ({
      file_id:	String,
      file_size:	Fixnum,
      file_path:	String
      })
  end

  class Message < Type
    hash_accessors ({
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
    })
  end

end
