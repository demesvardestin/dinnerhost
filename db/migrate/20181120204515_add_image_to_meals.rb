class AddImageToMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :image, :string, default: ""
  end
end
