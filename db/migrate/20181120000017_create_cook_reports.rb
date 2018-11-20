class CreateCookReports < ActiveRecord::Migration[5.0]
  def change
    create_table :cook_reports do |t|
      t.string :report_type
      t.text :details
      t.integer :chef_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
