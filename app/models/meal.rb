class Meal < ApplicationRecord
    
    belongs_to :chef
    has_many :reservations
    has_many :customers, through: :reservations
    has_many :meal_reports
    has_many :meal_ratings
    has_many :wishlists
    has_many :ingredients, dependent: :destroy
    
    scope :not_deleted, -> { where(deleted: false) }
    
    geocoded_by :full_address
    after_validation :geocode
    
    mount_uploader :image, ImageUploader
    
    after_create :create_rating, :set_address, :check_if_chef_live
    
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
    
    def self.search(param)
        matches('tags', param)
    end
    
    def self.search_by(field_name, param)
        matches(field_name, param)
    end
    
    def self.filter_by_customer_location(location)
        self.near(location, 15)
    end
    
    def self.process_filters(filter_data, filtered_by_type_and_location)
        if filter_data
          filtered_by_temp = if filter_data["temp"]
            filtered_by_type_and_location.where(serving_temperature: filter_data["temp"])
          end || filtered_by_type_and_location
          
          filtered_by_flavor = if filter_data["flavor"]
            filtered_by_temp.where(flavor: filter_data["flavor"])
          end || filtered_by_temp
          
          filtered_by_course = if filter_data["course"]
            filtered_by_flavor.where(course: filter_data["course"])
          end || filtered_by_flavor
          
          filtered_by_allergen = if filter_data["allergen"]
            filtered_by_course.search_by("allergens", filter_data["allergen"])
          end || filtered_by_course
          
          filtered_by_tags = if filter_data["tags"]
            filtered_by_allergen.search_by("tags", filter_data["tags"])
          end || filtered_by_allergen
          
          filtered_by_time = if filter_data["timeline"]
            filtered_by_tags.sort_by(&:created_at).reverse
          end || filtered_by_tags
          
          filtered_by_price = if filter_data["price"]
            if filter_data["price"] == "lowest"
              filtered_by_time.sort_by(&:floated_fee)
            else
              filtered_by_time.sort_by(&:floated_fee).reverse
            end
          end || filtered_by_time
          
          filtered_by_price
        else
          filtered_by_type_and_location
        end
    end
    
    def self.matches(field_name, type)
        where("lower(#{field_name}) like ?", "%#{type}%")
    end
    
    def prep_fee_float
        prep_fee.to_f
    end
    
    def allergen_list
        !allergens.empty? ? "the following allergens: #{allergens}" : "no allergens"
    end
    
    def tags_list
        !allergens.empty? ? tags.split(',').map { |t| '#' + t } : []
    end
    
    def average_rating
        (meal_ratings.map(&:value).sum/rating_count).to_f
    end
  
    def rating_count
        meal_ratings.count
    end
    
    def slug
        name.split(' ').join('-')
    end
    
    def url_link
        "/dish/#{id}/#{slug}"
    end
    
    def floated_fee
        prep_fee.to_i
    end
    
    def link
        "https://dinnerhost.co/dish/#{self.id}/#{self.slug}"
    end
    
    def not_yet_created
        id.nil?
    end
    
    protected
    
    def create_rating
        MealRating
        .create(value: 5, meal_id: self.id, customer_id: 1, details: "This is an automated DinnerHost bot review.")
    end
    
    def set_address
        street_address = self.chef.street_address
        town = self.chef.town
        state = self.chef.state
        zipcode = self.chef.zipcode
        
        self.update(street_address: street_address, town: town, state: state, zipcode: zipcode)
    end
    
    def check_if_chef_live
        chef = self.chef
        return if chef.live
        chef.update(live: true)
    end
    
end
