class Store < ApplicationRecord
    
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
    geocoded_by :full_address
    after_validation :geocode, :update_firebase
    
    has_many :past_orders
    has_many :orders
    
    scope :live, -> { where('live = ? ', true) }
    
    def full_address
        [street_address, town, state, zipcode].join(', ') 
    end
    
    def has_a_bank_account
        !stripe_cus.empty? && stripe_connected
    end
    
    def is_pending
        !stripe_cus.empty? && stripe_connected == false
    end
    
    def is_verified
        has_a_bank_account
    end
    
    def has_no_hours
        weekday_hours.empty? || saturday_hours.empty? || sunday_hours.empty? 
    end
    
    def actions_required
        actions = ''
        if has_no_hours
            actions << 'Your hours of operations are incomplete (You must set them up before going live).|'
        end
        if !has_a_bank_account
            actions << 'Your bank account is not set up yet, which means we are unable to process payments on your behalf. You can still receive order requests, but your customers will have to pay at the counter (pickup orders), or in cash (delivery orders).|'
        end
        if !live
            actions <<  'Your store is not yet live.'
        end
        actions
    end
    
    def get_delivery_fee
        if delivery_fee == '0.00'
            'free'
        else
            '$' + delivery_fee
        end
    end
    
    def delivers_for_free
        delivery_fee == '0.00' 
    end
    
    def completed_orders
        Order.where('store_id = ? AND processed = ?', self.id, true).reverse
    end
    
    def unprocessed_orders
        Order.where('store_id = ? AND processed = ?', self.id, false)
    end
    
    def all_orders
        Order.where('store_id = ?', self.id)
    end
    
    def is_not_related_to(cart)
       cart.store_id != self.id 
    end
    
    def weekday_hours
      [opening_weekday, closing_weekday].uniq.join(' - ')
    end
    
    def saturday_hours
      [opening_saturday, closing_saturday].uniq.join(' - ')
    end
    
    def sunday_hours
      [opening_sunday, closing_sunday].uniq.join(' - ')
    end
    
    def slug
        unslug = self.name + ' ' + self.town + ' ' + self.state
        return unslug.downcase.split(' ').join('-')
    end
    
    def to_slug(string)
        string.downcase.split(' ').join('-')
    end
    
    def unslug(string)
        string.downcase.split('-').join(', ')
    end
    
    def url
        "/stores/#{self.slug}/#{self.id}"
    end
    
    def full_address_without_zip
        [street, town, state].join(', ')
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
