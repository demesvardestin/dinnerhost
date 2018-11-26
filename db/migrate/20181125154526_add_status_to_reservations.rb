class AddStatusToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :accepted, :boolean
    add_column :reservations, :accepted_on, :datetime
    add_column :reservations, :denied_on, :datetime
    add_column :reservations, :request_time, :string, default: ''
  end
end
