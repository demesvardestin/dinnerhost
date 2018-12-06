class AddSomeAdditionalDetails < ActiveRecord::Migration[5.0]
  def change
    change_column_default :chefs, :username, from: '', to: nil
    add_column :chefs, :live, :boolean, default: false
  end
end
