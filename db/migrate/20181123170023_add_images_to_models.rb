class AddImagesToModels < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :image, :string, default: ''
    add_column :customers, :image, :string, default: ''
  end
end
