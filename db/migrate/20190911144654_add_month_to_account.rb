class AddMonthToAccount < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :month, :datetime
  end
end
