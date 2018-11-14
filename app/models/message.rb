class Message < ApplicationRecord
    belongs_to :conversation
    has_one :customer
    has_one :chef
    
    def sender
        sender_type = self.sender_type
        return (sender_type == "customer" ? Customer.find_by(id: self.customer_id) : Chef.find_by(id: self.chef_id))
    end
end
