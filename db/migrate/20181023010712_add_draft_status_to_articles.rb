class AddDraftStatusToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :draft, :boolean, default: false
  end
end
