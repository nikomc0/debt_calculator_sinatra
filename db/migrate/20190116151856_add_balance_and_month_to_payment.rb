class AddBalanceAndMonthToPayment < ActiveRecord::Migration[5.2]
  def change
  	add_column 	:payments, :month, :datetime
  	add_column 	:payments, :balance, :decimal, precision: 10, scale: 2

  end
end
