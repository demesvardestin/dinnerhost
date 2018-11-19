class MealReport < ApplicationRecord
    belongs_to :meal
    belongs_to :customer
end
