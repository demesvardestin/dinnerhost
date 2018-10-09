class AddApprovalTokenToRegistrationRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :registration_requests, :token, :string
    add_column :registration_requests, :url, :string
  end
end
