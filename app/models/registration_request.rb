class RegistrationRequest < ApplicationRecord
    validates_presence_of :store_name, :store_address, :store_manager,
                            :store_phone, :store_email, :store_website,
                            presence: true
end
