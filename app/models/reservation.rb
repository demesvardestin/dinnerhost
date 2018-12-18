class Reservation < ApplicationRecord
    belongs_to :customer
    belongs_to :chef
    has_one :reservation_cancellation
    
    scope :pending, -> { where(accepted: nil, cancelled: false) }
    scope :accepted, -> { where(accepted: true, cancelled: false) }
    scope :denied, -> { where(accepted: false) }
    scope :recent_first, -> { order("created_at DESC") }
    scope :upcoming, -> { where(accepted: true, completed: false) }
    scope :completed, -> { where(accepted: true, completed: true) }
    scope :cancelled, -> { where(cancelled: true) }
    
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
    
    def price
        fee.to_f
    end
    
    def meals
        meals_ = begin
            Meal.find(self.meal_ids.split(',').map { |m| m.to_i })
        rescue
            meal_ids.split(',').map do |i|
                Meal.find_by(id: i.to_i)
            end.compact
        end
        return meals_
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
    
    def allergens
        allergies.empty? ? nil : allergies
    end
    
    def allergens_present?
        allergies.empty? ? "none" : allergies
    end
    
    def status
        if cancelled
            "cancelled"
        elsif completed
            "completed"
        elsif accepted.nil?
            "pending"
        elsif accepted == false
            "denied"
        elsif accepted
            "accepted"
        end
    end
    
    def pending
        status == "pending"
    end
    
    def denied
        status == "denied"
    end
    
    def upcoming
        accepted && !completed
    end
    
    def acceptable
        !accepted && !cancelled
    end
    
    def status_color
        case status
        when "pending"
            "text-muted"
        when "accepted"
            "theme-green"
        when "denied"
            "theme-yellow"
        when "cancelled"
            "theme-red"
        end
    end
    
    def request_period_stringified
        [request_date.to_datetime.strftime("%b %e at "), request_time]
        .join(' ')
    end
    
    def request_period
        request_period_stringified.to_datetime
    end
    
    def request_period_differential
        (request_period.to_i - Time.zone.now.to_i)/86400.to_f
    end
    
    def cancellable?
        !cancelled && request_period_differential > 0
    end
    
    def late_cancellation
        request_period_differential < 2
    end
    
    def very_late_cancellation
        request_period_differential < 1
    end
    
    def last_minute_cancellation
        request_period_differential < 0.5
    end
    
    def refund_amount
        fee_ = fee.to_f
        req= request_period_differential
        
        fee_= case
        when req < 0.5
            fee_ * 0.25
        when req < 1
            fee_ * 0.50
        when req < 2
            fee_ * 0.75
        else
            fee_
        end.round(2)
    end
    
    def self.sort_by_spec load_, spec, current_chef
        return case load_
        when "pending"
          current_chef.reservations.pending
        when "upcoming"
          current_chef.reservations.upcoming
        when "denied"
          current_chef.reservations.denied
        when "completed"
          current_chef.reservations.completed
        when "cancelled"
          current_chef.reservations.cancelled
        else
          current_chef.reservations
        end.sort_by(&spec.to_sym)
    end
end
