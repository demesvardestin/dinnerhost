class AddSuspendedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :suspended, :boolean, default: false
    add_column :customers, :accepted_guidelines_on, :datetime
    add_column :chefs, :suspended, :boolean, default: false
    add_column :chefs, :accepted_guidelines_on, :datetime
  end
end
