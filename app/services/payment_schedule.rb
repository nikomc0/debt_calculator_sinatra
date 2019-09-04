module PaymentSchedule
	# TODO
	# attr_accessor

	def initialize(args)
		# TODO
		num_accounts = args[:total_accounts]
		# TODO needs to be calculated prior to landing here.
		monthly_interest = args[:monthly_interest]
		monthly_payment = args[:monthly_payment]
		month_created = args[:month_created]
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