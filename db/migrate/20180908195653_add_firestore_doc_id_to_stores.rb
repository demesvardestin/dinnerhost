class AddFirestoreDocIdToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :firestore_doc_id, :string
    add_column :stores, :firebase_initialized, :boolean, default: false
  end
end
