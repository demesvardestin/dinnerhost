class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :cart_id
      t.integer :store_id
      t.string :shopper_email, default: ''
      t.boolean :guest, default: false
      t.string :item_list, default: ''
      t.string :item_list_count, default: ''
      t.string :total, default: ''
      t.string :stripe_charge_id, default: ''
      t.string :confirmation, default: ''
      t.string :address, default: ''
      t.string :phone_number, default: ''
      t.integer :apartment_number, default: ''
      t.datetime :ordered_at
      t.boolean :online, default: true
      t.boolean :delivered, default: false
      t.boolean :processed, default: false
      t.string :status, default: ''
      t.string :delivery_email, default: ''
      t.string :delivery_option, default: ''
      t.string :shopper_uid, default: ''
      t.string :delivery_day, default: ''
      t.string :delivery_time, default: ''
      t.string :delivery_instructions, default: ''
      t.string :details, default: ''
      t.string :order_type, default: ''
      t.string :contact_name, default: ''
      t.string :pickup_time, default: ''

      t.timestamps
    end
  end
end
