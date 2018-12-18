class AddCompletedToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :completed, :boolean, default: false
  end
end
