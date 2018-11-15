class AddArchivedByToConversations < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :archived_by, :string, default: ""
    add_column :customers, :user_type, :string, default: "customer"
    add_column :chefs, :user_type, :string, default: "chef"
    add_column :conversations, :last_accessed_by_user_type, :string
    add_column :conversations, :last_accessed_by_user_id, :integer
  end
end
