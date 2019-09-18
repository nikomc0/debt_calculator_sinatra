class PaymentSchedule
	# TODO
	attr_accessor :account, :month_created, :month

	def initialize(account)
		@account = account
		@month_created = account[:created_at]
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
		calculate_pay_schedule(@account)
		@account.save
	end

	def monthly_interest(account)
		monthly_interest = (@account.apr / 100) / 12
	end

	def monthly_payment
		# $monthly_payment refers to the monthly payment the user decides is affordable (aka monthly budget)
		monthly_payment = $monthly_payment / Account.where("principal > 0").count
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
