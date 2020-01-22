require_relative '../helpers/raw_sql_helper'
require_relative '../helpers/finance_calculations'
 
class PaymentSchedule
  attr_accessor :account, :month_created, :month, :monthly_budget

  include ::FinanceCalculations

  def initialize(account, monthly_budget)
    @account = account
    @monthly_budget = monthly_budget
    post_initialize
  end

  def post_initialize
    @account.clear_payments
    @account.current_month
    @account[:monthly_interest] = monthly_interest(@account[:apr])
    @account[:monthly_payment]  = monthly_payment(@monthly_budget, $total_accounts, @account[:min_payment])
    @account[:num_months]       = num_months(@account[:monthly_interest], @account[:principal], @account[:monthly_payment])
    @account.save
    calculate_pay_schedule
  end
 
	include ::RawSqlHelper
	def bulk_import(payments)
		# Building RAW SQL Queries
		values_string = payments.map do |payment|
			"(#{sql_quote(payment[:account_id])}, #{sql_quote(payment[:payment])}, #{sql_quote(payment[:created_at])}, #{sql_quote(payment[:updated_at])}, #{sql_quote(payment[:month])}, #{sql_quote(payment[:balance])})"
		end.join(',')

		query = <<-SQL 
    INSERT INTO payments (account_id, payment, created_at, updated_at, month, balance)
    VALUES #{values_string}
    SQL

	  get_conn.exec_query(query)
	end
end