class MainController < ApplicationController
    
    skip_before_action :verify_authenticity_token, only: [:account]
    before_action :authenticate_customer!, only: [:rate, :report]
    
    def index
    end
    
    def search
        meal_type = params[:meal_type] || ""
        location = params[:request_location] || ""
        @meals = Meal.near(location, 5).filter_type(meal_type)
    end
    
    def rate
        @rating = ChefRating.create(rating_params)
        respond_to do |format|
          if @rating.save
            @cook = Chef.find_by(id: @rating.chef_id)
            format.js { render 'rated', :layout => false }
          end
        end
    end
  
    def report
        @report = CookReport.new(cook_report_params)
        respond_to do |format|
          if @report.save
            format.js { render 'report_sent', :layout => false }
          end
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
    
    def rating_params
        params.require(:chef_rating).permit(:value, :chef_id, :customer_id, :details)
    end
    
    def cook_report_params
        params.require(:cook_report).permit(:report_type, :details, :chef_id, :customer_id)
    end
    
end