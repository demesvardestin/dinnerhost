class Conversation < ApplicationRecord
    has_many :messages, dependent: :destroy
    belongs_to :chef
    belongs_to :customer
    
    def participants
        [self.chef, self.customer]
    end
    
    def self.not_archived(user)
        sender_type = user.user_type
        self.where("archived_by NOT LIKE '%#{sender_type}%'")
    end
    
    def self.archived(user)
        sender_type = user.user_type
        self.where("archived_by LIKE '%#{sender_type}%'")
    end
    
    def verify_last_accessed_by(user)
        if self.last_accessed.to_datetime < user.last_sign_in_at
            self.update(last_accessed: Time.zone.now)
        end
    end
    
    def correspondent(messager)
        return (messager.user_type == "customer" ? Chef.find_by(id: self.chef_id) : Customer.find_by(id: self.customer_id))
    end
end
