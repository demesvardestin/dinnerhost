class AddChargeIdToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :charge_id, :string
    add_column :chefs, :booking_rate, :string
  end
end
