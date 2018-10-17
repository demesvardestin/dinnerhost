class AddDetailsToSpecialOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :special_orders, :picked_up, :boolean, default: false
  end
end
