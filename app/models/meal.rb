class Meal < ApplicationRecord
    
    belongs_to :chef
    has_many :reservations
    has_many :customers, through: :reservations
    has_many :meal_reports
    
    geocoded_by :full_address
    after_validation :geocode
    
    mount_uploader :image, ImageUploader
    
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
    
    def prep_fee_float
        prep_fee.to_f
    end
    
    def allergen_list
        !self.allergens.empty? ? "the following allergens: #{self.allergens}" : "no allergens"
    end
    
    def tags_list
        !self.allergens.empty? ? self.tags.split(',').map { |t| '#' + t } : []
    end
    
end
