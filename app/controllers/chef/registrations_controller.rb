class Chef::RegistrationsController < Devise::RegistrationsController
    
    # include Accessible
    # skip_before_action :check_user, only: :destroy
    before_action :configure_permitted_parameters, if: :devise_controller?
    
    def create
        build_resource(sign_up_params)
     
        if resource.save
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_navigational_format?
            sign_up(resource_name, resource)
            if request.xhr?
                return render "chefs/new_chef_js", :layout => false
            else
                return render "chefs/new_chef_html", :layout => false
            end
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
            expire_session_data_after_sign_in!
            return render :json => {:success => true}
          end
        else
            clean_up_passwords resource
            # return render :json => {:success => false}
            return render "chefs/no_signup", :layout => false
        end
    end
    
    protected
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :first_name, :last_name, :phone_number])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
        devise_parameter_sanitizer.permit(:account_update, keys: [:password, :password_confirmation, :current_password])
    end
    
    def after_sign_up_path_for(resource)
        new_user_guidelines_path
    end
    
    # def after_sign_in_path_for(resource)
    #     dashboard_path
    # end

end