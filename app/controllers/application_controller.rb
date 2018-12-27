class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_https
  before_action :redirect_uri?
  before_action :load_customer, :load_cook, :load_meal
  before_action :store_customer_location!, if: :storable_location?
  before_action :find_reservation
  
  private
  
  def url
    request.original_url
  end
  
  def check_https
    url = URI.parse(request.original_url)
    if url.scheme == 'http' && request.original_url.ends_with?('.com/')
      # redirect_to 'https://senzzu.com'
    end
  end
  
  def redirect_uri?
      
  end
  
  def load_customer
    @customer = Customer.find_by(id: params[:customer_id]) || Customer.find_by(id: params[:id]) || Customer.find_by(id: params[:correspondent_id]) || Customer.new
  end
  
  def load_cook
    @cook = Chef.find_by(id: params[:id]) || Chef.find_by(username: params[:username]) || Chef.find_by(shortened_url: params[:shortened_url]) || Chef.find_by(id: params[:correspondent_id]) || Chef.new
  end
  
  def load_meal
    if url.include?("dish/") || url.include?("meals/")
      @meal = Meal.find_by(id: params[:id])
    end
  end
  
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
  end

  def store_customer_location!
    store_location_for(:customer, request.fullpath)
  end
  
  def find_reservation
    @reservation = Reservation.find_by(id: params[:reservation])
  end
  
  def _500_
    "/500"
  end
  
  def _404_
    "/404"
  end
  
  def _422_
    "/422"
  end
  
end
