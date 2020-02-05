module FinanceCalculations
	# Credit Card Minimum Payment is just a simple percentage of the principal.
	# def minimum_payment
	# 	BigDecimal(self.principal) * 0.03
	# end

	def minimum_payment(*args)
		apr = self.apr
		principal = self.principal

		args.map do |x|
			if x.include?('principal')
				principal = BigDecimal(x[:principal])
			end

			if x.include?('apr')
				apr = BigDecimal(x[:apr])
			end
		end

		# Interest Rate / Number of payments per year X Prinicipal = Interest
		'%.2f' % BigDecimal(((apr / 100) / 12) * principal)
	end

	def monthly_interest(apr)
		(apr / 100) / 12
	end

	def monthly_payment(monthly_budget, total_accounts, min_payment)
		usable_budget = monthly_budget / total_accounts

		if min_payment && min_payment > 0
			usable_budget += min_payment
		end

		usable_budget
	end

	def num_months(monthly_interest, principal, monthly_payment)
		top = Math.log(1 - (monthly_interest * principal) / (-monthly_payment))
		bottom = Math.log(1 + monthly_interest)

		num_months = top / bottom

		num_months.ceil
	end

	def calculate_pay_schedule
		@account.num_months(@account[:monthly_payment], @account[:principal], @account[:monthly_payment])
		payment = @account[:monthly_payment]
		month   = @account[:month]

		payments = []

		@account[:num_months].times do |i|
			accrued_interest = ((@account[:apr] / 100) / 365) * 30 * @account[:principal]
			# updated_balance  = @account[:principal] + accrued_interest
			updated_balance = @account[:principal]

			upcoming_month = month.next_month
			month = upcoming_month
			now = DateTime.now.in_time_zone('Pacific Time (US & Canada)')

			if payment >= updated_balance
				payment = updated_balance
				updated_balance -= payment
				@account[:principal] = updated_balance

				payments << {account_id: account.id, payment: payment, created_at: now, updated_at: now, month: upcoming_month, balance: updated_balance}
			
			else
				# updated_balance += accrued_interest
				updated_balance -= payment
				@account[:principal] = updated_balance

				payments << {account_id: account.id, payment: payment, created_at: now, updated_at: now, month: upcoming_month, balance: updated_balance}
			end
		end
		bulk_import(payments)
	end
end