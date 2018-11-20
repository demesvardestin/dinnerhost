class ChefRating < ApplicationRecord
    belongs_to :customer
    belongs_to :chef
end
