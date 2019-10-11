class PaymentSchedule
	# TODO
	attr_accessor :account, :month_created, :month, :monthly_budget

	def initialize(account, monthly_budget)
		@account = account
		@month_created = account[:created_at]
		@monthly_budget = monthly_budget
		post_initialize(@account)
	end

	def post_initialize(account)
		if account.paid_payments.count > 0
			@account.month = account.paid_payments.last.month
		else
			@account.month = @month_created
		end
		@account.save
	end

	def get_schedule
		@account.clear_payments
		@account[:monthly_interest] = monthly_interest(@account)
		@account[:monthly_payment] 	= monthly_payment
		@account[:num_months] 			= num_months(@account)
<<<<<<< HEAD
		# min_monthly_payment
		@account.save
=======
		min_monthly_payment

>>>>>>> parent of 2edc8ff... Add minimum payment calculation for accounts
		calculate_pay_schedule(@account)
		@account.save
	end

	def monthly_interest(account)
		monthly_interest = (@account.apr / 100) / 12
	end

	# TO DO
	# If an account has a minimum monthly payment configured
	# apply the min payment and remove from available monthly budget.
	def min_monthly_payment
		accounts_with_min_payments = Account.where("user_id = ? AND min_payment != ? OR min_payment != ?", @account.user_id, nil, 0)
	end

	def monthly_payment
		accounts_with_balances = Account.where("user_id = ? AND principal > ?", @account.user_id, 0).count

		monthly_payment = @monthly_budget / accounts_with_balances
	end

	def num_months(account)
		num_months = Math.log(1 - (account.monthly_interest * account.principal) / (-account.monthly_payment)) / Math.log(1 + account.monthly_interest)
		num_months.ceil
	end

	def calculate_pay_schedule(account)
		payment = account.monthly_payment
		month = account.month
		updated_balance = account.principal

		# Create payment schedule
		while updated_balance > 0 do
			upcoming_month = month.next_month
			month = upcoming_month

			if payment >= updated_balance
				payment = updated_balance
				updated_balance -= payment

				Payment.create(
					account_id: account.id, 
					payment: payment, 
					month: upcoming_month, 
					balance: updated_balance
				)
			else
				updated_balance -= payment

				Payment.create(
					account_id: account.id, 
					payment: payment, 
					month: upcoming_month, 
					balance: updated_balance
				)
			end
		end
	end
end
