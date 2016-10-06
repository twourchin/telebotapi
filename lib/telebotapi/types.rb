class TeleBotApi

  class Type

    def Type.createAccessors(hash)
      self.send(:define_method, 'tele_fields', proc{hash})
      hash.each do |k,v|
        self.send(:define_method, k, proc{self.instance_variable_get("@#{k.to_s}")})
        self.send(:define_method, "#{k.to_s}=", proc{|v| self.instance_variable_set("@#{k.to_s}", v)})
      end
    end

    def parseHash(hash)
      hash.each do |k,v|
        case tele_fields[k].to_s
        when 'Fixnum', 'String', 'TrueClass', 'FalseClass', 'Float'
          self.instance_variable_set("@#{k.to_s}", v)
        else
          if tele_fields[k].instance_of?(Array)
            array = []
            v.each do |value|
              array.push tele_fields[k][0].new(value)
            end
            self.instance_variable_set("@#{k.to_s}", array)
          else
            self.instance_variable_set("@#{k.to_s}", tele_fields[k].new(v))
          end
        end
      end
    end

    def initialize(hash)
      parseHash(hash)
    end

    def match(hash)
      compareResult = true
      hash.each do |key, value|
        if self.respond_to? "#{key.to_s}"
          instanceVariable = self.instance_variable_get "@#{key.to_s}"
          if instanceVariable.respond_to? 'compare'
            compareResult = (compareResult and instanceVariable.compare(value))
          else
            if value.instance_of? Proc
              compareResult = (compareResult and (value.call(instanceVariable)))
            else
              compareResult = (compareResult and (instanceVariable == value))
            end
          end
        else
          compareResult = false
        end
        unless compareResult
          break
        end
      end
      return compareResult
    end

  end

  class User < Type
    createAccessors ({
      id:	Fixnum,
      first_name:	String,
      last_name:	String,
      username:	String
    })
  end

  class Chat < Type
    createAccessors ({
      id:	Fixnum,
      type:	String,
      title:	String,
      username:	String,
      first_name:	String,
      last_name:	String
    })
  end

  class MessageEntity < Type
    createAccessors ({
      type:	String,
      offset:	Fixnum,
      length:	Fixnum,
      url:	String,
      user:	TeleBotApi::User,
      last_name:	String
    })
  end

  class Audio < Type
    createAccessors ({
      file_id:	String,
      duration:	Fixnum,
      performer:	String,
      title:	String,
      mime_type:	String,
      file_size:	Fixnum
    })
  end

  class PhotoSize < Type
    createAccessors ({
      file_id:	String,
      width:	Fixnum,
      height:	Fixnum,
      file_size:	Fixnum,
      file_path: String
    })
  end

  class Video < Type
    createAccessors ({
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
    createAccessors ({
        file_id:	String,
        width:	Fixnum,
        height:	Fixnum,
        thumb:	PhotoSize,
        emoji:	String,
        file_size:	Fixnum
    })
  end

  class Voice < Type
    createAccessors ({
      file_id:	String,
      duration:	Fixnum,
      mime_type:	String,
      file_size:	Fixnum
    })
  end

  class Document < Type
    createAccessors ({
      file_id:	String,
      thumb:	TeleBotApi::PhotoSize,
      file_name:	String,
      mime_type:	String,
      file_size:	Fixnum,
    })
  end

  class Voice < Type
    createAccessors ({
      file_id:	String,
      duration:	Fixnum,
      mime_type:	String,
      file_size:	Fixnum
    })
  end

  class Contact < Type
    createAccessors ({
      phone_number:	String,
      first_name:	String,
      last_name:	String,
      user_id:	Fixnum
    })
  end

  class Location < Type
    createAccessors ({
      longitude:	Float,
      latitude:	Float
    })
  end

  class Venue < Type
    createAccessors ({
      location:	TeleBotApi::Location,
      title:	String,
      address:	String,
      foursquare_id:	String
    })
  end

  class Message < Type
    createAccessors ({
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

  class File < Type
    createAccessors ({
      file_id:	String,
      file_size:	Fixnum,
      file_path:	String
    })
  end

end
