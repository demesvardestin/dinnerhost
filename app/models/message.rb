class Message < ApplicationRecord
    belongs_to :conversation
    has_one :customer
    has_one :chef
    
    after_create :update_chat
    
    def user_type
        self.sender_type
    end
    
    def sender
        return (user_type == "customer" ? Customer.find_by(id: self.customer_id) : Chef.find_by(id: self.chef_id))
    end
    
    def receiver
        return (user_type == "chef" ? Customer.find_by(id: self.conversation.customer_id) : Chef.find_by(id: self.conversation.chef_id))
    end
    
    def content_snipet
        content.truncate(60)
    end
    
    def extended_content_snipet
        content.truncate(150)
    end
    
    protected
    
    def update_chat
        conversation.update(updated_at: Time.zone.now)
    end
end
