class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_https
  before_action :redirect_uri?
  # before_action :initialize_cart
  
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
  
end
