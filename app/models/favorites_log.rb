class FavoritesLog < ApplicationRecord
    
    def self.add_new(store_id, shopper_id)
        self.create(store_id: store_id, shopper_id: shopper_id)
    end
    
end
