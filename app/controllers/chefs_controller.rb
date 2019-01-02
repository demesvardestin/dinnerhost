class ChefsController < ApplicationController
  before_action :set_cook, except: :show
  before_action :authenticate_chef!, except: :show
  before_action :load_booking_estimate, only: [:booking_estimate, :reserve]
  before_action :load_reservations, except: [:show]
  
  
  def onboarding
    
  end
  
  def dashboard
  end
  
  def verify_bank
    begin
      begin
        acct = Stripe::Account.retrieve(current_chef.stripe_token)
      rescue
        acct = Stripe::Account.create(
          :type => 'custom',
          :country => 'US',
          :email => current_chef.email
        )
      end
      acct.tos_acceptance.date = Time.now.to_i
      acct.tos_acceptance.ip = request.ip
      acct.legal_entity.type = 'individual'
      data = params[:data]
      acct.external_accounts.create(external_account: data[:token])
      acct.legal_entity.address.line1 = current_chef.street_address
      acct.legal_entity.address.city = current_chef.town
      acct.legal_entity.address.state = current_chef.state
      acct.legal_entity.address.postal_code = current_chef.zipcode
      acct.legal_entity.dob.day = data[:dob].split('/')[1]
      acct.legal_entity.dob.month = data[:dob].split('/')[0]
      acct.legal_entity.dob.year = data[:dob].split('/')[2]
      acct.legal_entity.first_name = current_chef.first_name
      acct.legal_entity.last_name = current_chef.last_name
      acct.legal_entity.ssn_last_4 = data[:last_4]
      acct.save
      current_chef.update(stripe_token: acct.id, has_stripe_account: true, stripe_bank_token: data[:bankToken])
      @notice = "Account successfully created!"
      render 'bank_verified', :layout => false
    rescue Exception => e
      @error = e
      render 'stripe_account_error', :layout => false
    end
  end
  
  def trigger_payout
    begin
      # balance = current_chef.stripe_balance_in_cents
      Stripe::Payout.create(
        {
          :amount => 3000,
          :currency => "usd",
          :method => "standard"
        },
        {:stripe_account => Chef.first.stripe_token}
      )
    rescue Stripe::StripeError => e
      p e
      render "payout_failed", :layout => false
      return
    end
    render :layout => false
  end
  
  def show
    @cook = Chef.find_by(id: params[:id]) || Chef.find_by(username: params[:username])
  end
  
  def edit
  end
  
  def update
    @cook.update(chef_params)
    respond_to do |format|
      if @cook.save
        format.js { render 'update_confirmation', :layout => false }
      else
        format.js { render 'update_failed', :layout => false }
      end
    end
  end
  
  def reservations
    @status = "pending"
  end
  
  def accept_reservation
    @reservation = Reservation.find(params[:id])
    @customer = @reservation.customer
    @cook.accept_reservation @reservation
    
    begin
      Reservation.charge_customer @reservation
      render :layout => false
      
      UserMailer.reservation_accepted(@reservation).deliver_now
      MessageUpdate.reservation_accepted(@reservation)
    rescue
      @notice = "Unable to process this request at this time. Please try again."
      render "common/error", :layout => false
    end
  end
  
  def deny_reservation
    @reservation = Reservation.find(params[:id])
    @pending = Reservation.where(chef_id: current_chef.id).pending
    @cook.deny_reservation @reservation
    render :layout => false
    
    UserMailer.reservation_denied(@reservation).deliver_now
    MessageUpdate.reservation_denied(@reservation)
  end
  
  def load_reservations_category
    @category = params[:category]
    
    @reservations = case @category
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
    end
    
    render "load_reservations", :layout => false
  end
  
  def sort_reservations
    @sort_by = params[:sort_by]
    @load = params[:load]
    
    @reservations = Reservation.sort_by_spec @load, @sort_by, current_chef
    
    @sort_by = "Date Requested" if params[:sort_by] == "request_period"
    
    render "sort_reservations", :layout => false
  end
  
  def view_request
    @reservation = Reservation.find_by(id: params[:id])
    @customer = @reservation.customer
    @meals = @reservation.meals
    redirect_to :back if @reservation.nil? || @reservation.chef != current_chef
  end
  
  def message_diner
    @diner = Customer.find_by(id: params[:id])
    return if current_chef.cannot_message @diner
    
    @conversation = Conversation.find_by(chef_id: current_chef.id, customer_id: @diner.id)
    if @conversation.nil?
      @conversation = Conversation.create(chef_id: current_chef.id, customer_id: @diner.id)
    end
    redirect_to chat_path(:id => @conversation.id)
  end
  
  def rate_diner
    chef = Chef.find_by(id: params[:diner_rating][:chef_id])
    @customer =  Customer.find_by(id: params[:diner_rating][:customer_id])
    
    if chef.has_not_rated @customer
        @rating = DinerRating.create(rating_params)
        respond_to do |format|
          @notice = "Thank you for your feedback!"
          if @rating.save
            format.js { render 'diner_rated', :layout => false }
          end
        end
    else
        @notice = "Can't perform this action at this time"
        render 'common/unauthorized', :layout => false
    end
  end
  
  def accepted
    @reservation = Reservation.find(params[:id])
    redirect_to :back, notice: "Page not accessible" if @reservation.cancelled
  end
  
  def all_accepted
    @status = "accepted"
    @accepted = Reservation.where(chef_id: current_chef.id).accepted
  end
  
  def denied
    @status = "denied"
    @denied = Reservation.where(chef_id: current_chef.id).denied
  end
  
  def pending
    @status = "pending"
    @pending = Reservation.where(chef_id: current_chef.id).pending
  end
  
  private
  
  def set_cook
    @cook = current_chef
  end
  
  def rating_params
    params.require(:diner_rating).permit(:value, :chef_id, :customer_id, :details)
  end
  
  def load_reservations
    @reservations = Reservation.where(chef_id: current_chef.id).order("created_at DESC")
    @accepted = @reservations.accepted.reverse
    @denied = @reservations.denied.reverse
    @pending = @reservations.pending.reverse
  end
  
  def chef_params
    params
    .require(:chef)
    .permit(:first_name, :last_name, :phone_number, :twitter, :facebook, :instagram,
            :pinterest, :bio, :street_address, :town, :state, :zipcode, :booking_rate,
            :username, :image, :license)
  end
  
end
