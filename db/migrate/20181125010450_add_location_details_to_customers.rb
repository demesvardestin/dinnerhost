class AddLocationDetailsToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :street_address, :string, default: ''
    add_column :customers, :town, :string, default: ''
    add_column :customers, :state, :string, default: ''
    add_column :customers, :zipcode, :string, default: ''
    add_column :customers, :latitude, :float
    add_column :customers, :longitude, :float
  end
end
