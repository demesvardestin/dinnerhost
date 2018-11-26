class Reservation < ApplicationRecord
    belongs_to :customer
    belongs_to :chef
    
    scope :pending, -> { where(accepted: nil) }
    scope :accepted, -> { where(accepted: true) }
    scope :denied, -> { where(accepted: false) }
    
    def self.book_chef(meal, token, customer)
        charge = Stripe::Charge.create(
            {
                :amount => meal.chef.booking_rate.to_i * 100,
                :currency => "usd",
                :source => token,
                :description => "Booking for meal #{meal.id}",
                # :destination => {
                #     :amount => total_amount - fee,
                #     :account => self.get_store.stripe_cus,
                # }
            }
        )
        res = Reservation.create(meal_id: meal.id, charge_id: charge.id, customer_id: customer.id)
        res
    end
    
    def people_count
        adult_count + children_count
    end
    
    def meals
        Meal.find(self.meal_ids.split(',').map { |m| m.to_i })
    end
    
    def user
        self.chef || self.customer
    end
    
    def requested_for
        request_date.to_datetime.strftime('%b %e, %Y') + ' at ' + request_time
    end
    
    def allergen_list
        allergies.split(',')
    end
end
