class AddLicenseToChefs < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :license, :string, default: 'none'
  end
end
