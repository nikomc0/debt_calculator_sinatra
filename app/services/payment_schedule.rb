class PaymentSchedule
	# TODO
	attr_accessor :account, :account_name, :monthly_interest, :monthly_payment, :month_created

	def initialize(account)
		# TODO
		@account = account
		@account_name = @account[:account_name]
	end

	def get_schedule
		@account.clear_payments
		@account[:monthly_interest] = monthly_interest(@account)
		@account[:monthly_payment] = monthly_payment
		@account[:num_months] = num_months(@account)
		calculate_pay_schedule(@account)
		@account.save
	end

	def monthly_interest(account)
		monthly_interest = (@account.apr / 100) / 12
	end

	def monthly_payment
		# $monthly_payment refers to the monthly payment the user decides is affordable (aka monthly budget)
		monthly_payment = $monthly_payment / $total_accounts
	end

	def num_months(account)
		num_months = -Math.log(1 - (account.monthly_interest * account.principal) / account.monthly_payment) / Math.log(1 + account.monthly_interest)
	end

	def calculate_pay_schedule(account)
		payment = account.monthly_payment
		month = account.created_at
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