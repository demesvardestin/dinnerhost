class AddDishDetailsToMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :serving_temperature, :string, default: ''
    add_column :meals, :allergens, :string, default: ''
    add_column :meals, :dish_order, :string, default: ''
    add_column :meals, :tags, :string, default: ''
  end
end
