class ShoppersController < ApplicationController
    
    def firebase_authentication
        data = params["data"]
        @email = data["email"]
        @password = data["password"]
        @phone = data["phone"]
        @auth_type = data["authType"]
        render :layout => false
    end
    
    def add_data_to_firestore
        data = params["data"]
        @type = data["type"]
        @shopper_uid = data["shopperUID"]
        @shopper_phone = data["shopperPhone"]
        @shopper_email = data["shopperEmail"]
        @shopper_address = data["shopperAddress"]
        @apartment_number = data["shopperAptNumber"]
        @shopper_name = data["shopperName"]
        render :layout => false 
    end
    
    def read_data_from_firestore
        data = params["data"]
        @store = Store.find_by(id: params["data"]["storeID"])
        @store_id = @store.id if @store
        @cart = Cart.where(shopper_email: guest_shopper.email).last
        @type = data["type"]
        @shopper_id = data["shopperID"] || ''
        @url = request.original_url
        render :layout => false 
    end
    
    def order_history
        @orders = Order.where(shopper_id: params[:shopper_id])
    end
    
end