class AddDeletedToModels < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :deleted, :boolean, default: false
    add_column :chefs, :deleted, :boolean, default: false
    add_column :customers, :deleted, :boolean, default: false
    add_column :reservations, :deleted, :boolean, default: false
  end
end
