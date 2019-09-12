class AddMonthToAccount < ActiveRecord::Migration[5.2]
  def change
  	add_column :accounts, :month, :datetime
  end
end
