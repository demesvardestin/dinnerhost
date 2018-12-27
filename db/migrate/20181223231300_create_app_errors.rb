class CreateAppErrors < ActiveRecord::Migration[5.0]
  def change
    create_table :app_errors do |t|
      t.string :error_type
      t.text :details
      t.boolean :resolved, default: false
      t.string :object_type
      t.integer :object_id

      t.timestamps
    end
  end
end
