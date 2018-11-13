class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.integer :customer_id
      t.integer :reservation_id
      t.string :fee, default: '0.00'
      t.datetime :made_on, default: Time.zone.now
      t.timestamps
    end
  end
end
