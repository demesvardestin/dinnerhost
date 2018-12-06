class CreateMealRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :meal_ratings do |t|
      t.integer :value
      t.integer :meal_id
      t.integer :customer_id
      t.text :details

      t.timestamps
    end
  end
end
