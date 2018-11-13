class AddTypeToMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :meal_type, :string
    add_column :meals, :chef_id, :integer
    add_column :reservations, :meal_id, :integer
  end
end
