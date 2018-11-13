class Meal < ApplicationRecord
    
    belongs_to :chef
    has_many :reservations
    has_many :customers, through: :reservations
    
    geocoded_by :full_address
    after_validation :geocode
    
    def full_address
        [street_address, town, state, zipcode].join(' ')
    end
    
    def self.filter_type(type)
        type.strip!
        type.downcase!
        (type_matches(type)).uniq
    end
    
    def self.type_matches(type)
        matches('meal_type', type)
    end
    
    def self.matches(field_name, type)
        where("lower(#{field_name}) like ?", "%#{type}%")
    end
    
end
