class AddAddressToChefs < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :street_address, :string
    add_column :chefs, :town, :string
    add_column :chefs, :state, :string
    add_column :chefs, :zipcode, :string
  end
end
