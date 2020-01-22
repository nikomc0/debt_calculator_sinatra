class AddPaymentsToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column  :accounts, :account_id, :integer
    add_index   :accounts, :account_id
  end
end
