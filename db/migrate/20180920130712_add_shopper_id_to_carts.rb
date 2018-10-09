class AddShopperIdToCarts < ActiveRecord::Migration[5.0]
  def change
    add_column :carts, :shopper_id, :string, default: ''
    add_column :stores, :category, :string, default: ''
    add_column :registration_requests, :category, :string, default: ''
    add_column :carts, :items_price_list, :string, default: ''
    add_column :carts, :item_list_name, :string, default: ''
    add_column :carts, :item_tax_list, :string, default: ''
  end
end
