class CreateDinerRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :diner_ratings do |t|
      t.float :value
      t.integer :customer_id
      t.integer :chef_id
      t.text :details

      t.timestamps
    end
  end
end
