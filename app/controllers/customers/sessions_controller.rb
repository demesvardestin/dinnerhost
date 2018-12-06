# frozen_string_literal: true

class Customers::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    # resource = Customer.find_for_database_authentication(email: params[:customer][:email])
    # return invalid_login_attempt unless resource
  
    # if resource.valid_password?(params[:customer][:password])
    #   sign_in :customer, resource
    #   return render '/customers/logged_in_customer', :layout => false
    # end
    
    # invalid_login_attempt
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected
  
  def invalid_login_attempt
    set_flash_message(:alert, :invalid)
    render json: flash[:alert], status: 401
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
