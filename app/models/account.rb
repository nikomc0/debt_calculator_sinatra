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

	# def calculate_pay_schedule
	# 	# Calculates how many months are required to pay down debt amount.
	# 	num_accounts = $total_accounts
	# 	monthly_interest = (self.apr / 100) / 12
	# 	payment = $monthly_payment / num_accounts
	# 	month = self.created_at
	# 	updated_balance = self.principal

	# 	num_months = -Math.log(1 - (monthly_interest * self.principal) / payment) / Math.log(1 + monthly_interest)

	# 	# Create payment schedule
	# 	while updated_balance > 0 do
	# 		upcoming_month = month.next_month
	# 		month = upcoming_month

	# 		if payment >= updated_balance
	# 			payment = updated_balance
	# 			updated_balance -= payment

	# 			Payment.create(account_id: self.id, payment: payment, month: upcoming_month, balance: updated_balance)
	# 		else
	# 			updated_balance -= payment

	# 			Payment.create(account_id: self.id, payment: payment, month: upcoming_month, balance: updated_balance)
	# 		end
	# 	end
	# end

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
