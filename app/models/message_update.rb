class MessageUpdate
   
    def self.alert_customer(phone, message, store=nil)
        twilio, twilio_phone = self.twilio
        twilio.messages.create(
            body: message,
            to: phone,
            from: twilio_phone
        )
    end
    
    def self.twilio
        twilio = self.initialize_twilio
        twilio_phone = ENV["TWILIO_PHONE"]
        return twilio, twilio_phone
    end
    
    def self.twilio_token
        ENV["TWILIO_TOKEN"]
    end
    
    def self.initialize_twilio
        account_sid = ENV["TWILIO_SID"]
        auth_token = ENV["TWILIO_TOKEN"]
        return Twilio::REST::Client.new account_sid, auth_token
    end
    
end