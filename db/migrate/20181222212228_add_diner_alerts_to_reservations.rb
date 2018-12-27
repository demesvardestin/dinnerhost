class AddDinerAlertsToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :diner_alerted, :boolean, default: false
    add_column :reservations, :diner_alerted_on, :datetime
    add_column :reservations, :diner_alerts_sent, :integer, default: 0
  end
end
