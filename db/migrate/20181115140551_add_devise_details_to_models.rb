class AddDeviseDetailsToModels < ActiveRecord::Migration[5.0]
    def change
      change_table :chefs do |t|
  
        ## Trackable
        t.integer  :sign_in_count, default: 0, null: false
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.string     :current_sign_in_ip
        t.string     :last_sign_in_ip
  
      end
      
      change_table :customers do |t|
  
        ## Trackable
        t.integer  :sign_in_count, default: 0, null: false
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.string     :current_sign_in_ip
        t.string     :last_sign_in_ip
  
      end
    end
end
