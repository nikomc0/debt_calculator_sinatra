class Account < ActiveRecord::Base
	belongs_to :user
	has_many :payments
	has_many :paid_payments

	def clear_payments
		self.payments.destroy_all
		ActiveRecord::Base.connection.reset_pk_sequence!('payments')
		self.reload.payments
	end

	def clear_accounts
		self.accounts.delete_all
		self.reload.payments
	end
end
