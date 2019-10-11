class AddPaymentScheduleToAccounts < ActiveRecord::Migration[5.2]
  def change
  	add_column :accounts, :monthly_interest, :decimal, precision: 10, scale: 2
  	add_column :accounts, :monthly_payment, :decimal, precision: 10, scale: 2
  end
end
