class RegistrationRequest < ApplicationRecord
    
    validates_presence_of :store_name, :store_address, :store_manager,
                            :store_phone, :store_email, :store_website,
                            presence: true
    
    def approve
        token = rand(00000000000000000000000000..9130924093023002398023082400824084)
        until !RegistrationRequest.exists?(token: token)
            self.approve
        end
        self.update(token: token, url: "/store/signup?token=#{token}")
    end
    
end
