class CreateReferrals < ActiveRecord::Migration[5.0]
  def change
    create_table :referrals do |t|
      t.integer :referrer_id
      t.string :referrer_type
      t.string :code_value, default: ''
      t.boolean :applied, default: false

      t.timestamps
    end
    
    add_column :customers, :credit_value, :float, default: 0.0
    add_column :customers, :referral_code, :string
    add_column :chefs, :referral_id, :integer
  end
end
