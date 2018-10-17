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
        @store_id = data["storeID"]
        @doc_id = data["docID"]
        @shopper_uid = data["shopperUID"]
        @shopper_phone = data["shopperPhone"]
        @shopper_email = data["shopperEmail"]
        @shopper_address = data["shopperAddress"]
        @apartment_number = data["shopperAptNumber"]
        @shopper_name = data["shopperName"]
        @content = URI.decode(data["content"])
        author_string = data["author"]
        @author = author_string.split(' ')[0] + author_string.split(' ')[1][0]
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
    
    def create_special_order
        @order = SpecialOrder.new(special_orders_params)
        respond_to do |format|
            if @order.save
                format.js { render :layout => false }
            else
                format.js { render 'item_request_error', :layout => false }
            end
        end
    end
    
    private
    
    def special_orders_params
        params.require(:special_order).permit(:item_name, :item_size, :item_description, :item_price, :availability_date, :store_id) 
    end
    
end