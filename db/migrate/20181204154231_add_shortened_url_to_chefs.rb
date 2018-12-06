class AddShortenedUrlToChefs < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :shortened_url, :string
    add_column :chefs, :has_stripe_account, :boolean, default: false
    add_column :chefs, :stripe_token, :string
    add_column :customers, :has_stripe_account, :boolean, default: false
    add_column :customers, :stripe_token, :string
    add_column :customers, :stripe_last_4, :string
    add_column :customers, :card_brand, :string
  end
end
