class AddCardTokenToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :token, :string
  end
end
