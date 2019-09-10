class AddMonthToPaidPayments < ActiveRecord::Migration[5.2]
  def change
  	add_column 	:paid_payments, :month, :datetime
  end
end
