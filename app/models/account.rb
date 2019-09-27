class Account < ActiveRecord::Base
	belongs_to :user
	has_many :payments
	has_many :paid_payments

	def update_global_variables(user)
		$total_accounts = user.accounts.all.length
		$accounts = user.accounts.all
		$total_debt = user.accounts.sum(:principal)
		$monthly_budget = user.monthly_budget
	end

	def update_payment_schedule(user)
		monthly_budget = user.monthly_budget
		Account.where("principal > 0").each do |account|
			PaymentSchedule.new(account, monthly_budget).get_schedule
		end
	end

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
