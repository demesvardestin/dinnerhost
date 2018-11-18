class ChefsController < ApplicationController
  before_action :authenticate_chef!, except: :show
  
  def dashboard
  end
  
  def show
    @chef = Chef.find_by(id: params[:id]) || Chef.find_by(username: params[:username])
  end
  
  private
  
  def chef_params
    params.require(:chef)
    .permit(:first_name, :last_name, :phone_number, :twitter, :facebook, :instagram,
            :pinterest, :bio, :street_address, :town, :state, :zipcode, :booking_rate,
            :username)
  end
  
end
