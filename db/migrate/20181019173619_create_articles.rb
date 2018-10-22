class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title, default: ''
      t.text :content, default: ''
      t.string :author, default: ''
      t.string :tags, default: ''
      t.integer :admin_id
      t.string :banner_image, default: 'https://s3.us-east-2.amazonaws.com/senzzu/stores_banner.png'

      t.timestamps
    end
  end
end
