class ModifyChefDefaultImage < ActiveRecord::Migration[5.0]
  def change
    change_column :chefs, :image, :string, default: nil
  end
end
