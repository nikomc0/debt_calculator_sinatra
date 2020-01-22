class CreatePayments < ActiveRecord::Migration[5.2]
  def change
  	 create_table :payments do |t|
      t.integer         :account_id
      t.numeric         :payment, precision: 26, scale: 2
 
      t.timestamps null: false
    end
  end
end
