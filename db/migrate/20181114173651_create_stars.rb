class CreateStars < ActiveRecord::Migration[5.0]
  def change
    create_table :stars do |t|
      t.integer :conversation_id
      t.integer :owner_id
      t.string :owner_type

      t.timestamps
    end
  end
end
