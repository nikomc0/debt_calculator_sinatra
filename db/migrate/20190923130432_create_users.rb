class CreateUsers < ActiveRecord::Migration[5.2]
  def change
  	create_table :users do |t|
  		t.string :first_name, null: false
  		t.string :last_name, null: false
  		t.string :user_name, null: false
      t.decimal :monthly_budget, precision: 10, scale: 2
  		t.string :password_hash, null: false
  		t.boolean :user, :default => true
  		t.timestamps null: false
  	end
  end
end
