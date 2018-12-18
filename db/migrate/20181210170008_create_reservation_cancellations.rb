class CreateReservationCancellations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservation_cancellations do |t|
      t.text :reason
      t.boolean :approved, default: false
      t.datetime :approved_on
      t.datetime :denied_on
      t.integer :customer_id
      t.integer :reservation_id

      t.timestamps
    end
    
    add_column :reservations, :cancelled, :boolean, default: false
    add_column :reservations, :cancelled_on, :datetime
  end
end
