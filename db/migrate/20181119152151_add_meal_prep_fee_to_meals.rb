class AddMealPrepFeeToMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :prep_fee, :string, default: '0.00'
  end
end
