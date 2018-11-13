class CreateChefs < ActiveRecord::Migration[5.0]
  def change
    create_table :chefs do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :twitter
      t.string :facebook
      t.string :instagram
      t.string :pinterest
      t.text :bio
      
      t.timestamps
    end
  end
end
