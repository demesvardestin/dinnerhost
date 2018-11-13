class AddAddressToMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :street_address, :string
    add_column :meals, :town, :string
    add_column :meals, :state, :string
    add_column :meals, :zipcode, :string
    add_column :meals, :latitude, :float
    add_column :meals, :longitude, :float
  end
end
