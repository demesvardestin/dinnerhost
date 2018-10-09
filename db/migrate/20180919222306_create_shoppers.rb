class CreateShoppers < ActiveRecord::Migration[5.0]
  def change
    create_table :shoppers do |t|
      t.string :email, default: ''

      t.timestamps
    end
  end
end
