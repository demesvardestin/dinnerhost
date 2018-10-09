class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores do |t|

      t.timestamps
      t.string :name, default: ''
      t.string :street_address, default: ''
      t.string :town, default: ''
      t.string :state, default: ''
      t.string :zipcode, default: ''
      t.string :stripe_cus, default: ''
      t.boolean :active, default: true
      t.boolean :live, default: false
      t.boolean :stripe_connected, default: false
      t.string :npi, default: ''
      t.string :website, default: ''
      t.string :phone, default: ''
      t.string :supervisor, default: ''
      t.boolean :receives_push, default: false
      t.string :push_endpoint, default: ''
      t.string :sub_auth, default: ''
      t.string :p256dh, default: ''
      t.float :latitude, default: 0.0
      t.float :longitude, default: 0.0
      t.boolean :on_trial, default: true
      t.string :opening_weekday, default: '9:00AM'
      t.string :closing_weekday, default: '9:00PM'
      t.string :opening_saturday, default: '9:00AM'
      t.string :closing_saturday, default: '9:00PM'
      t.string :opening_sunday, default: '9:00AM'
      t.string :closing_sunday, default: '9:00PM'
      
    end
  end
end
