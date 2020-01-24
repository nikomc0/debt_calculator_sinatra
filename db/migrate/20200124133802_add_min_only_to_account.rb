class AddMinOnlyToAccount < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :min_only, :boolean, :default => false
  end
end
