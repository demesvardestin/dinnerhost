class AddFurtherDetailsToChefs < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :username, :string, default: "", unique: true
  end
end
