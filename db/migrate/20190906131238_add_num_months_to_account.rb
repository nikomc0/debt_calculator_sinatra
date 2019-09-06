class AddNumMonthsToAccount < ActiveRecord::Migration[5.2]
  def change
  	add_column :accounts, :num_months, :integer
  end
end
