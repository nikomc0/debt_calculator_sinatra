class PaymentSchedule
	# TODO
	attr_accessor :account, :account_name, :monthly_interest, :monthly_payment, :month_created

	def initialize(account)
		# TODO
		@account = account
		@account_name = @account[:account_name]
	end

	def get_schedule
		puts "Account is #{@account_name}"
		puts "Monthly interest is #{monthly_interest(@account)}"
		puts "Monthly Payment is #{monthly_payment}"
	end

	def monthly_interest(account)
		monthly_interest = (@account.apr / 100) / 12
	end

	def monthly_payment
		# $monthly_payment refers to the monthly payment the user decides is affordable (aka monthly budget)
		monthly_payment = $monthly_payment / $total_accounts
	end

	def calculate_pay_schedule
		# Calculates how many months are required to pay down debt amount.
		num_accounts = $total_accounts
		monthly_interest = (self.apr / 100) / 12
		payment = $monthly_payment / num_accounts
		month = self.created_at
		updated_balance = self.principal

		num_months = -Math.log(1 - (monthly_interest * self.principal) / payment) / Math.log(1 + monthly_interest)

		# Create payment schedule
		while updated_balance > 0 do
			upcoming_month = month.next_month
			month = upcoming_month

			if payment >= updated_balance
				payment = updated_balance
				updated_balance -= payment

				Payment.create(account_id: self.id, payment: payment, month: upcoming_month, balance: updated_balance)
			else
				updated_balance -= payment

				Payment.create(account_id: self.id, payment: payment, month: upcoming_month, balance: updated_balance)
			end
		end
	end
end