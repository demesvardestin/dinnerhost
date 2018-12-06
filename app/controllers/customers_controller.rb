class CustomersController < ApplicationController
    before_action :authenticate_customer!
    before_action :set_customer
    before_action :own_reservations, only: :reservation_meals
    before_action :load_featured_meals, only: [:index, :featured_listings]
    
    def edit
    end
    
    def edit_verification
    end
    
    def submit_token
        source = params[:customer][:stripe_token][:id]
        brand = params[:customer][:stripe_token][:card][:brand]
        last_4 = params[:customer][:stripe_token][:card][:last4]
        return if source.nil? || source.empty?
        
        begin
            stripe_acct = Stripe::Customer.retrieve(current_customer.stripe_token)
            stripe_acct.sources.last.delete
            stripe_acct.sources.create(source: source)
        rescue
            description = "Customer: #{current_customer.full_name}. ID: #{current_customer.id}"
            stripe_acct = Stripe::Customer.create(:description => description, :source => source)
        end
        
        current_customer.update(stripe_token: stripe_acct.id, has_stripe_account: true, stripe_last_4: last_4, card_brand: brand)
        
        @notice = "Payment updated!"
        render 'token_submitted', :layout => false
    end
    
    def index
        @chefs = Chef.near(current_customer.full_address, 15).live
    end
    
    def featured_listings
    end
    
    def update
        @customer.update(customer_params)
        @notice = "Profile updated!"
        respond_to do |format|
            if @customer.save
                format.js { render :layout => false }
            end
        end
    end
    
    def bookings
        @bookings = current_customer.reservations
    end
    
    def reservation_meals
        @meals = @reservation.meals
    end
    
    private
    
    def set_customer
        @customer = current_customer
    end
    
    def own_reservations
        @reservation = Reservation.find_by(id: params[:id])
        redirect_to root_path if !(current_customer.reservations.include? @reservation)
    end
    
    def customer_params
        params
        .require(:customer)
        .permit(:first_name, :last_name, :phone_number, :twitter, :facebook, :instagram,
            :bio, :street_address, :town, :state, :zipcode, :image, :stripe_token)
    end
    
    def load_featured_meals
        @meals = Meal.filter_by_customer_location(current_customer.full_address)
    end
end
