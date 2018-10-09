class AddCustomerEmailToPastOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :past_orders, :customer_email, :string
  end
end
