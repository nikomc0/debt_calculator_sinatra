class AddMinPaymentToAccount < ActiveRecord::Migration[5.2]
  def change
  	add_column :accounts, :min_payment, :decimal, precision: 10, scale: 2
  end
end
