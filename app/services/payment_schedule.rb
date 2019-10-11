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
		if account.min_payment === 0
			@account.min_payment = nil
		else
			@monthly_budget -= account.min_payment
		end

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
		@account[:monthly_payment]  = monthly_payment
		@account[:num_months] 			= num_months(@account)
		# min_monthly_payment
		@account.save
		calculate_pay_schedule(@account)
	end

	def monthly_interest(account)
		monthly_interest = (account.apr / 100) / 12
	end

	def monthly_payment
		if @account.min_payment && @account.min_payment > 0
			@account.min_payment
		else
			accounts_with_min_payments = Account.where("user_id = ? AND principal > ? AND min_payment IS NOT NULL", @account.user_id, 0)
			accounts_with_balances = Account.where("user_id = ? AND principal > ? AND min_payment IS NULL", @account.user_id, 0)
			usable_budget = @monthly_budget - accounts_with_min_payments.sum(:min_payment)
			
			monthly_payment = usable_budget / accounts_with_balances.count
		end
	end

	def num_months(account)
		num_months = Math.log(1 - (account.monthly_interest * account.principal) / (-account.monthly_payment)) / Math.log(1 + account.monthly_interest)
		num_months.ceil
	end

	def calculate_pay_schedule(account)
		payment = account.monthly_payment
		month = account.month
		p account.monthly_interest
		accrued_interest = account.principal * account.monthly_interest
		updated_balance = account.principal + accrued_interest

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
				updated_balance += accrued_interest
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
