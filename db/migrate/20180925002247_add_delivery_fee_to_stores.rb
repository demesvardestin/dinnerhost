class AddDeliveryFeeToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :delivery_fee, :string, default: '0.00'
    add_column :stores, :banner_image, :string, default: 'https://s3.us-east-2.amazonaws.com/senzzu/store_login_banner.png'
  end
end
