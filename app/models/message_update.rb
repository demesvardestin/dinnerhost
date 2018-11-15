class MessageUpdate
   
    def self.alert_receiver(message, sender, receiver)
        twilio, twilio_phone = self.twilio
        message_header = "#{sender.first_name} has sent you a message on DinnerHost: \n\n"
        message_footer = "\n\nGo to dinnerhost.co/inbox to reply."
        twilio.messages.create(
            body: message_header + message.extended_content_snipet + message_footer,
            to: receiver.phone_number,
            from: twilio_phone
        )
    end
    
    def self.twilio
        twilio = self.initialize_twilio
        # twilio_phone = ENV["TWILIO_PHONE"]
        twilio_phone = "12018491397"
        return twilio, twilio_phone
    end
    
    def self.twilio_token
        ENV["TWILIO_TOKEN"]
    end
    
    def self.initialize_twilio
        # account_sid = ENV["TWILIO_SID"]
        account_sid = "AC372a0064c4d35fd5aaeea6c791fb8663"
        # auth_token = ENV["TWILIO_TOKEN"]
        auth_token = "d08b231a3e1026c359dcc6b2f916c851"
        return Twilio::REST::Client.new account_sid, auth_token
    end
    
end