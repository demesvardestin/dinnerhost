class CreateIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :quantity
      t.text :additional_details
      t.integer :chef_id
      t.integer :meal_id

      t.timestamps
    end
  end
end
