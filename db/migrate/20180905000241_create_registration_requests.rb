class CreateRegistrationRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :registration_requests do |t|
      t.string :store_name
      t.string :store_address
      t.string :store_manager
      t.string :store_phone
      t.string :store_email
      t.string :store_website

      t.timestamps
    end
  end
end
