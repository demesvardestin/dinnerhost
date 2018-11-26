class AddFurtherDetailsToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :allergies, :string
    add_column :reservations, :meal_ids, :string
    add_column :reservations, :request_date, :string
    add_column :reservations, :chef_id, :integer
    add_column :reservations, :additional_message, :text
    add_column :reservations, :active, :boolean, default: false
  end
end
