class AddBioToAdmins < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :bio, :text
  end
end
