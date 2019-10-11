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

  def update_global_variables(user)
    $total_accounts = user.accounts.all.length
    $accounts = user.accounts.all
    $total_debt = user.accounts.sum(:principal)
    $monthly_budget = user.monthly_budget
  end

  def update_payment_schedule(user)
    monthly_budget = user.monthly_budget

    Account.where("user_id = ? AND principal > ?", user.id, 0).each do |account|
      PaymentSchedule.new(account, monthly_budget).get_schedule
    end
  end
end