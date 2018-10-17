class CreateStoreReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :store_reviews do |t|
      t.string :content
      t.integer :store_id
      t.string :author
      t.string :shopper_id
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
