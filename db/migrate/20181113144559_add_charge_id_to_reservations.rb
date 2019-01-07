class AddChargeIdToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :charge_id, :string
    add_column :chefs, :booking_rate, :string, default: "40.00"
  end
end
