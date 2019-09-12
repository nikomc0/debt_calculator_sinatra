class PaymentSchedule
	# TODO
	attr_accessor :account, :month_created, :month

	def initialize(account)
		@account = account
		@month_created = account[:created_at]
		@month = account[:month] || account.paid_payments.last.month
	end

	def get_schedule
		p @month
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
		num_months = Math.log(1 - (account.monthly_interest * account.principal) / (-account.monthly_payment)) / Math.log(1 + account.monthly_interest)
		num_months.ceil
	end

	def calculate_pay_schedule(account)
		payment = account.monthly_payment
		month = @month
		updated_balance = account.principal

		puts "Account created #{@month_created}"
		puts "Last Payment #{month}"
		puts @account.paid_payments.last.month

		# Create payment schedule
		# while updated_balance > 0 do
		# 	upcoming_month = month.next_month
		# 	month = upcoming_month

		# 	if payment >= updated_balance
		# 		payment = updated_balance
		# 		updated_balance -= payment

		# 		Payment.create(
		# 			account_id: account.id, 
		# 			payment: payment, 
		# 			month: upcoming_month, 
		# 			balance: updated_balance
		# 		)
		# 	else
		# 		updated_balance -= payment

		# 		Payment.create(
		# 			account_id: account.id, 
		# 			payment: payment, 
		# 			month: upcoming_month, 
		# 			balance: updated_balance
		# 		)
		# 	end
		# end
	end
end
