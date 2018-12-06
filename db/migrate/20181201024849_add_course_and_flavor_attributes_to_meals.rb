class AddCourseAndFlavorAttributesToMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :course, :string, default: ""
    add_column :meals, :flavor, :string, default: ""
  end
end
