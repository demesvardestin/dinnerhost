class CreatePastOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :past_orders do |t|
      t.string :total
      t.string :details
      t.string :order_type
      t.string :status
      t.string :additional_details
      t.string :confirmation
      t.string :delivery_address
      t.string :delivery_phone
      t.string :delivery_name
      t.string :pickup_contact
      t.string :pickup_time
      t.integer :store_id
      t.string :shopper_id

      t.timestamps
    end
  end
end
