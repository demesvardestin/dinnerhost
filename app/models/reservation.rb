class Reservation < ApplicationRecord
    belongs_to :customer
    belongs_to :meal
    
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
end
