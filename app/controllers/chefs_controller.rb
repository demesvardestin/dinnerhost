class ChefsController < ApplicationController
  before_action :authenticate_chef!, except: [:show, :rate, :report]
  
  def dashboard
  end
  
  def show
    @cook = Chef.find_by(id: params[:id]) || Chef.find_by(username: params[:username])
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
  
  private
  
  def chef_params
    params.require(:chef)
    .permit(:first_name, :last_name, :phone_number, :twitter, :facebook, :instagram,
            :pinterest, :bio, :street_address, :town, :state, :zipcode, :booking_rate,
            :username)
  end
  
  def rating_params
    params.require(:chef_rating).permit(:value, :chef_id, :customer_id, :details)
  end
  
  def cook_report_params
    params.require(:cook_report).permit(:report_type, :details, :chef_id, :customer_id)
  end
  
end
