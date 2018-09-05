class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :retrieve_registration
  
  def url
    request.original_url
  end
  
  def retrieve_registration
    if url.include?('store/signup')
      @registration ||= RegistrationRequest.last
    end
  end
  
end
