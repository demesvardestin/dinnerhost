class MainController < ApplicationController
    
    skip_before_action :verify_authenticity_token, only: [:account]
    before_action :authenticate_customer!, only: [:rate, :rate_meal, :report]
    before_action :authenticate_user, only: :refer_a_chef
    
    def index
    end
    
    def search
        if params[:filters]
            @meal_type = params["meal_type"]
            @request_location = params["request_location"]
            @filter_data = JSON.parse(params["filters"]) if params["filters"]
            
            filtered_by_type_and_location = Meal.not_deleted.filter_type(@meal_type).near(@request_location, 20)
            @meals = Meal.process_filters(@filter_data, filtered_by_type_and_location)
        else
            meal_type = params[:meal_type] || ""
            location = params[:request_location] || ""
            @meals = Meal.not_deleted.near(location, 5).filter_type(meal_type)
        end
    end
    
    def rate
        customer = Customer.find_by(id: params[:chef_rating][:customer_id])
        @cook =  Chef.find_by(id: params[:chef_rating][:chef_id])
        
        if customer.has_not_rated @cook
            @rating = ChefRating.create(rating_params)
            respond_to do |format|
              if @rating.save
                format.js { render 'rated', :layout => false }
              end
            end
        else
            @notice = "Can't perform this action at this time"
            render 'common/unauthorized', :layout => false
        end
    end
    
    def rate_meal
        customer = Customer.find_by(id: params[:meal_rating][:customer_id])
        @meal =  Meal.find_by(id: params[:meal_rating][:meal_id])
        
        if customer.has_not_rated_meal @meal
            @rating = MealRating.create(meal_rating_params)
            respond_to do |format|
                if @rating.save
                    @reviews = @meal.meal_ratings.reverse
                    format.js { render 'meal_rated', :layout => false }
                end
            end
        else
            @notice = "Can't perform this action at this time"
            render 'common/unauthorized', :layout => false
        end
    end
  
    def report
        customer = Customer.find_by(id: params[:cook_report][:customer_id])
        @cook =  Chef.find_by(id: params[:cook_report][:chef_id])
        
        if customer.has_not_reported @cook
            @report = CookReport.new(cook_report_params)
            respond_to do |format|
              if @report.save
                format.js { render 'report_sent', :layout => false }
              end
            end
        else
            @notice = "Can't perform this action at this time"
            render 'common/unauthorized', :layout => false
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
    
    def refer_a_chef
        @user = current_customer || current_user
    end
    
    def submit_chef_referral
        chef_list = params[:chef_referral][:list]
        chef_list.split(',').each do |e|
            if e.try(:to_i)
                MessageUpdate.invite_chef(e, current_customer)
            else
                ReferralMailer.invite_chef(e, current_customer).deliver_now
            end
        end
        
        render "referrals_submitted", :layout => false
    end
    
    def verify_referral
        ref = params[:ref]
        customer = Customer.find_by(referral_code: ref)
        
        if customer == nil
            redirect_to root_path
            return
        end
        
        referral = Referral.create(code_value: ref, referrer_id: customer.id)
        
        if current_chef
            current_chef.update(referral_id: referral.id)
        end
        
        redirect_to root_path
    end
    
    private
    
    def rating_params
        params.require(:chef_rating).permit(:value, :chef_id, :customer_id, :details)
    end
    
    def meal_rating_params
        params.require(:meal_rating).permit(:value, :meal_id, :customer_id, :details)
    end
    
    def cook_report_params
        params.require(:cook_report).permit(:report_type, :details, :chef_id, :customer_id)
    end
    
    def authenticate_user
        authenticate_customer! || authenticate_chef!
    end
    
end