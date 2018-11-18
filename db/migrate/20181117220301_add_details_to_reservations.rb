class AddDetailsToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :start_date, :string, default: ''
    add_column :reservations, :end_date, :string, default: ''
    add_column :reservations, :adult_count, :integer, default: 0
    add_column :reservations, :children_count, :integer, default: 0
  end
end
