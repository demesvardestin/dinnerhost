class AddDeliveryMinimumToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :delivery_minimum, :string, default: '10.00'
  end
end
