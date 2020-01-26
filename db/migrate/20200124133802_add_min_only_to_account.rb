class AddMinOnlyToAccount < ActiveRecord::Migration[5.2]
  def change
  	add_column :accounts, :min_only, :boolean, :default => false
  end
end
