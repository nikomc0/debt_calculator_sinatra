class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
  	create_table :accounts do |t|
      t.string 		:account_name
      t.numeric 	:principal, precision: 10, scale: 2
      t.decimal 	:apr, precision: 10, scale: 2
      t.integer 	:due_date
      t.boolean 	:paid, :default => false
      t.timestamps null: false
    end
  end
end
