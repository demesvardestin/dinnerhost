class CreateFavoritesLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites_logs do |t|
      t.integer :store_id
      t.string :shopper_id

      t.timestamps
    end
  end
end
