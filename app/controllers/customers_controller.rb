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
        if source.nil? || source.empty?
            @notice = "Payment update failed. Please try again"
            render "common/error", :layout => false
            return
        end
        
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
        @chefs = Chef
        .near(current_customer
        .full_address("#{request.location.city}, #{request.location.state}"), 15)
        .live
    end
    
    def featured_listings
    end
    
    def save_listing
        @meal = Meal.find_by(id: params[:id])
        return if @meal.nil? or current_customer.has_saved(@meal)
        Wishlist.create(customer_id: current_customer.id, meal_id: @meal.id)
        render "listing_saved", :layout => false
    end
    
    def wishlist
        @saved = current_customer.wishlists.map(&:meal)
    end
    
    def update
        @customer.update(customer_params)
        respond_to do |format|
            if @customer.save
                if request.xhr?
                    @notice = "Profile updated!"
                    format.js { render :layout => false }
                else
                    format.html { redirect_to :back, notice: "Your profile has been updated!" }
                end
            else
                render :edit, notice: "Unable to update profile. Please try again"
            end
        end
    end
    
    def bookings
        @bookings = current_customer.reservations.order("created_at DESC")
    end
    
    def reservation_meals
        @meals = @reservation.meals
    end
    
    def message_chef
        @chef = Chef.find_by(id: params[:id])
        
        @conversation = Conversation.find_by(chef_id: @chef.id, customer_id: current_customer.id)
        if @conversation.nil?
          @conversation = Conversation.create(chef_id: @chef.id, customer_id: current_customer.id)
        end
        redirect_to chat_path(:id => @conversation.id)
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
        @meals = Meal
        .filter_by_customer_location(current_customer
        .full_address("#{request.location.city}, #{request.location.state}"))
        .not_deleted
    end
end
