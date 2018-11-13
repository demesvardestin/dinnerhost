class MainController < ApplicationController
    
    skip_before_action :verify_authenticity_token, only: [:account]
    
    def index
    end
    
    def search
        meal_type = params[:meal_type] || ""
        location = params[:request_location] || ""
        @meals = Meal.near(location, 5).filter_type(meal_type)
    end
    
    def search_store
        search = params["data"]["search"]
        search_type = params[:data][:search_type]
        if search_type == 'address'
            @stores = Store.near(search, 3).live
        else
            @stores = Store.search(search).live
        end
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
    
    private
    
end