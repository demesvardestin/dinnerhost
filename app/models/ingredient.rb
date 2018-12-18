class Ingredient < ApplicationRecord
    belongs_to :chef
    belongs_to :meal
    
    def user
        chef || customer
    end
end
