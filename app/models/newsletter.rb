class Newsletter < ApplicationRecord
    
    validates_presence_of :email
    
    def self.create_recipient(email)
        self.create(email: email)
    end
    
end
