class AddSenderTypeToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :sender_type, :string
  end
end
