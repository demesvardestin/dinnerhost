class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins do |t|
      t.string :first_name, default: ''
      t.string :last_name, default: ''
      t.string :profile_image, default: ''
      t.string :email, default: ''

      t.timestamps
    end
  end
end
