class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :conversation_id
      t.integer :chef_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
