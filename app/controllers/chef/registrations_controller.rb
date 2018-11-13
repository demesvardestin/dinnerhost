class Chef::RegistrationsController < Devise::RegistrationsController
    
    # include Accessible
    # skip_before_action :check_user, only: :destroy
    before_action :configure_permitted_parameters, if: :devise_controller?
    
    protected
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :first_name, :last_name])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
        devise_parameter_sanitizer.permit(:account_update, keys: [:password, :password_confirmation, :current_password])
    end
    
    def after_sign_up_path_for(resource)
        chef_dashboard_path
    end
    
    # def after_sign_in_path_for(resource)
    #     dashboard_path
    # end

end