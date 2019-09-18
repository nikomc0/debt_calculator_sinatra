class Account < ActiveRecord::Base
	has_many :payments
	has_many :paid_payments

	# TODO:
	# 1. Rename to Monthly Budget
	$monthly_payment = 2500.00

	def update_global_variables
		$total_accounts = Account.all.length
		$accounts = Account.all
		$total_debt = Account.sum(:principal)
	end

	def update_payment_schedule
		Account.where("principal > 0").each do |account|
			PaymentSchedule.new(account).get_schedule
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
