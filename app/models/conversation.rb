class Conversation < ApplicationRecord
    has_many :messages, dependent: :destroy
    belongs_to :chef
    belongs_to :customer
    
    def participants
        [self.chef, self.customer]
    end
end
