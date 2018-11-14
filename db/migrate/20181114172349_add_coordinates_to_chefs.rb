class AddCoordinatesToChefs < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :longitude, :float
    add_column :chefs, :latitude, :float
  end
end
