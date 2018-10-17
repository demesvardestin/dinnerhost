class CreateSpecialOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :special_orders do |t|
      t.string :item_name
      t.string :item_size
      t.string :item_description
      t.string :item_price
      t.string :availability_date
      t.integer :store_id
      t.string :shopper_phone, default: ''
      t.boolean :pending, default: false
      t.boolean :denied, default: false

      t.timestamps
    end
  end
end
