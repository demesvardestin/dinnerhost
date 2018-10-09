class CreateStripeAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_alerts do |t|
      t.string :account
      t.string :event_type
      t.string :authorization
      t.string :event_id
      t.string :disabled_reasons
      t.integer :due_by
      t.string :fields_needed
      t.string :destination

      t.timestamps
    end
  end
end
