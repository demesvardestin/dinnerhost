class CreateWishlists < ActiveRecord::Migration[5.0]
  def change
    create_table :wishlists do |t|
      t.integer :meal_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
