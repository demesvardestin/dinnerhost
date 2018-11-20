class CreateChefRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :chef_ratings do |t|
      t.integer :value
      t.integer :chef_id
      t.integer :customer_id
      t.text    :details

      t.timestamps
    end
  end
end
