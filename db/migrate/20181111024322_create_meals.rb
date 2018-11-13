class CreateMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :meals do |t|
      t.string :name
      t.text :description
      t.integer :host_id
      
      t.timestamps
    end
  end
end
