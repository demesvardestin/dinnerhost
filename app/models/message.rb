class Message < ApplicationRecord
    belongs_to :conversation
    has_one :customer
    has_one :chef
    
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
        self.content[0..60] + "..."
    end
    
    def extended_content_snipet
        self.content[0..150] + "..."
    end
end
