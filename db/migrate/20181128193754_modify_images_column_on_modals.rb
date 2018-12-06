class ModifyImagesColumnOnModals < ActiveRecord::Migration[5.0]
  def change
    change_column_default :chefs, :image, from: '', to: '/images/chef.png'
    change_column_default :customers, :image, from: '', to: '/images/no_avatar.png'
    add_column :chefs, :verified, :boolean, default: false
    add_column :chefs, :education, :string, default: "N/A"
    add_column :chefs, :languages, :string, default: "English"
    add_column :chefs, :government_id, :string, default: ''
    add_column :customers, :government_id, :string, default: ''
    add_column :customers, :facebook, :string, default: ''
    add_column :customers, :instagram, :string, default: ''
    add_column :customers, :twitter, :string, default: ''
    add_column :customers, :bio, :text, default: ''
  end
end
