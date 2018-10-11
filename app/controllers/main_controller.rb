class MainController < ApplicationController
    
    skip_before_action :verify_authenticity_token, only: [:account]
    
    def index
    end
    
    def account
        @type = params[:type]
        case @type
        when 'account.updated'
            @account = params[:account]
            @store = Store.find_by(stripe_cus: @account)
            @verification = params[:data][:object][:legal_entity][:verification]
            @authorization = @verification[:status]
            if @authorization == 'verified' && @store.stripe_connected == false
                @store.update(stripe_connected: true)
            end
            StripeAlert.create(
                account: @account,
                event_type: @type,
                authorization: @authorization,
                event_id: params[:id],
                disabled_reasons: @verification[:disabled_reason],
                due_by: @verification[:due_by],
                fields_needed: "#{@verification[:fields_needed]}"
            )
        when 'account.external_account.created'
            @account = params[:account]
            @store = Store.find_by(stripe_cus: @account)
            StripeAlert.create(
                account: @account,
                event_type: @type,
                event_id: params[:id]
            )
        when 'payout.failed'
            @account = params[:account]
            @store = Store.find_by(stripe_cus: @account)
            @destination = params[:data][:object][:destination]
            StripeAlert.create(
                account: @account,
                event_type: @type,
                event_id: params[:id],
                destination: @destination
            )
        end
        render :layout => false
    end
    
    def register_a_store
        @registration = RegistrationRequest.new
    end
    
    def register
        @registration = RegistrationRequest.new(registration_params)
        respond_to do |format|
          if @registration.save
            format.js { render :layout => false }
          end
        end
    end
    
    def uninitialize_firebase
        @store = current_store
        if @store.nil?
            render :layout => false
            return
        end
        @store.update(firebase_initialized: false)
        render :layout => false
    end
    
    def initialize_firebase
        @store = current_store
        if @store.nil?
            render :layout => false
            return
        end
        @store.update(firebase_initialized: true)
        render :layout => false
    end
    
    def search
        search = params[:q]
        @stores = Store.near(search, 3).live
    end
    
    def search_store
        search = params["data"]["search"]
        @stores = Store.near(search, 3).live
        if !@stores.empty?
            render :layout => false
        else
            render 'no_stores', :layout => false
        end
    end
    
    def subscribe
        email = params[:email]
        unless !Newsletter.exists?(email: email)
            render 'email_exists', :layout => false
            return
        end
        Newsletter.create_recipient(email)
        render :layout => false
    end
    
    def initialize_cart
        @cart = Cart.where(shopper_email: request.remote_ip, pending: true).last
        if @cart.nil?
            @cart = Cart.create(shopper_email: request.remote_ip, pending: true)
        end
    end
    
    def send_email
        ShopperMailer.order_receipt(Order.last.delivery_email, Cart.where(pending: true).last(2).first, Order.last)
        render :layout => false
    end
    
    private
    
    def registration_params
      params.require(:registration_request).permit(:store_name, :store_email, :store_address, :store_phone, :store_manager, :store_website)
    end
    
end