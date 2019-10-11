class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
  	create_table :accounts do |t|
      t.integer   :user_id
      t.string 		:account_name
      t.numeric 	:principal, precision: 10, scale: 2
      t.decimal 	:apr, precision: 13, scale: 9
      t.integer 	:due_date
      t.boolean 	:paid, :default => false
      t.timestamps null: false
    end
  end
end
