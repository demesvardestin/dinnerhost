class AddLastAccessedToConversations < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :last_accessed, :datetime
  end
end
