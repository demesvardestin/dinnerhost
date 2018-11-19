class CreateMealReports < ActiveRecord::Migration[5.0]
  def change
    create_table :meal_reports do |t|
      t.string :report_type
      t.text :details
      t.integer :meal_id
      t.integer :customer_id
      
      t.timestamps
    end
  end
end
