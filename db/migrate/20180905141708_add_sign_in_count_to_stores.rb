class AddSignInCountToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :sessions_count, :integer, default: 1
    add_column :stores, :token_id, :string, default: ''
  end
end
