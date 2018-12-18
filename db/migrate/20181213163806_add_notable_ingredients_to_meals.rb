class AddNotableIngredientsToMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :notable_ingredients, :text
  end
end
