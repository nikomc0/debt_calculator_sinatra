class AddPaidToPayment < ActiveRecord::Migration[5.2]
  def change
  	add_column 	:payments, :paid, :boolean, :default => false
  end
end
