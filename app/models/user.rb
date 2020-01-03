require_relative '../workers/big_job_v2'
require 'timer'

class User < ActiveRecord::Base
	has_many :accounts

	include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(attempted_password)
  	pp self.password
    if self.password == attempted_password
      true
    else
      false
    end
  end

  def get_accounts
    @accounts ||= accounts.all
  end

  def total_debt
    total = 0

    @accounts.each do |t|
      total += t.principal
    end

    total
  end

  def update_global_variables(user)
    $total_accounts = user.accounts.all.length
    $accounts = user.accounts.all
    $total_debt = user.accounts.sum(:principal)
    $monthly_budget = user.monthly_budget
  end

  def update_payment_schedule(user, account)
    timer = Timer.new()
    monthly_budget = user.monthly_budget

    timer.time do
      threads = []
      threads << Thread.new { PaymentSchedule.new(account, monthly_budget).get_schedule }
    #   Account.where("user_id = ? AND principal > ?", user.id, 0).each do |account|
    #     threads << Thread.new { PaymentSchedule.new(account, monthly_budget).get_schedule }
    #   end

      threads.each { |t| t.join }
    end
  end
end