class CookReport < ApplicationRecord
    belongs_to :customer
    belongs_to :chef
end
