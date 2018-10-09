class CreateCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :carts do |t|
      t.integer :item_count, default: 0
      t.string :shopper_email, default: ''
      t.string :total_cost, default: ''
      t.boolean :pending, default: false
      t.boolean :completed, default: false
      t.string :item_list, default: ''
      t.string :item_list_count, default: ''
      t.string :instructions_list, default: ''
      t.integer :order_id
      t.integer :store_id
      t.string :final_amount, default: ''
      t.boolean :paid, default: false
      t.string :current_location, default: ''

      t.timestamps
    end
  end
end
