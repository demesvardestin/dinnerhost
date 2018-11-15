class AddArchivedByToConversations < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :archived_by, :string, default: ""
    add_column :customers, :user_type, :string, default: "customer"
    add_column :chefs, :user_type, :string, default: "chef"
  end
end
