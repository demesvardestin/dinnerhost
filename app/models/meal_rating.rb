class MealRating < ApplicationRecord
    belongs_to :meal
    belongs_to :customer
    
    def last_of collection
        collection.last == self
    end
    
    def self.search(param)
        param.strip!
        param.downcase!
        (details_match(param)).uniq
    end
    
    def self.details_match(param)
        matches('details', param)
    end
    
    def self.matches(field_name, param)
        where("lower(#{field_name}) like ?", "%#{param}%")
    end
end
