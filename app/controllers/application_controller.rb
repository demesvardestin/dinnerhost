class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :retrieve_registration
  before_action :random_token
  # before_action :initialize_cart
  
  def url
    request.original_url
  end
  
  def retrieve_registration
    if url.include?('store/signup')
      @registration = RegistrationRequest.find_by(token: params[:token])
      if @registration.nil?
        redirect_to root_path
      end
    end
  end
  
  def random_token
    @token = rand(00000000000000000000000000..9130924093023002398023082400824084)
  end
  
  def initialize_cart
    @cart = Cart.where(shopper_email: request.remote_ip, pending: true).last
    if @cart.nil?
      @cart = Cart.create(shopper_email: request.remote_ip, pending: true)
    end
  end
  
end
