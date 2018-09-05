class Store::RegistrationsController < Devise::RegistrationsController
    
    # include Accessible
    # skip_before_action :check_user, only: :destroy
    before_action :configure_permitted_parameters, if: :devise_controller?
    
    protected
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :street_address, :town, :state, :zipcode, :name, :phone, :supervisor, :website])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
        devise_parameter_sanitizer.permit(:account_update, keys: [:password, :password_confirmation, :current_password])
    end
    
    def after_sign_up_path_for(resource)
        edit_profile_path
    end

end