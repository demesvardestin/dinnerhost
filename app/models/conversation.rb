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
end
