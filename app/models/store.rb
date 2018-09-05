class Store < ApplicationRecord
    
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
    geocoded_by :full_address
    after_validation :geocode, :update_firebase
    
    def full_address
        [street_address, town, state, zipcode].join(', ') 
    end
    
    protected
    
    def update_firebase
        pusher.trigger('firebase', 'firebase-snapshot', {
            message: "Update firebase",
            type: 'new',
            store_data: self.attributes
        })
    end
    
    def pusher
        return Pusher::Client.new(
            app_id: "521090",
            key: "6b4730083f66596ec97e",
            secret: "95a0a2107ac2e620e46a",
            cluster: 'us2'
        )
    end
    
end
