class ChefRating < ApplicationRecord
    belongs_to :customer
    belongs_to :chef
    
    def last_of collection
        collection.last == self
    end
    
end
