require_relative '../helpers/finance_calculations'

class Account < ActiveRecord::Base
	belongs_to :user
	has_many :payments
	has_many :paid_payments

	include ::FinanceCalculations

	def clear_payments
		bulk_delete(self.id)
		ActiveRecord::Base.connection.reset_pk_sequence!('payments')
		self.reload.payments
	end

	def clear_accounts
		self.accounts.delete_all
		self.reload.payments
	end

	def current_month
		if self.paid_payments.count > 0
			self.month = self.paid_payments.last.month
		else
			self.month = self.created_at
		end
	end

	def get_minimum_payment(params)
		min = self.minimum_payment(params)
		min.to_json
	end

	def find_minimum_payment
		self.minimum_payment
	end

	include ::RawSqlHelper

	def bulk_delete(account_id)
		query =	<<-SQL 
		WITH cte AS (SELECT id FROM payments WHERE payments.account_id = #{account_id}
		)
		DELETE FROM payments
		USING  cte;
		SQL

		get_conn.exec_query(query)
	end
end
