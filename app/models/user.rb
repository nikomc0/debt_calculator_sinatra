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

  def current_account(id)
    puts @accounts
    # @accounts.each do |t|
    #   if t.id === id
    #     t
    #   else
    #     "Account not found."
    #   end
    # end
  end

  def update_global_variables
    $total_accounts = self.get_accounts.length
    $accounts = self.get_accounts
    $total_debt = self.total_debt
    $monthly_budget = self.monthly_budget
  end

  def update_payment_schedule(user, account)
    monthly_budget = user.monthly_budget

    threads = []
  
    Account.where("user_id = ? AND principal > ?", user.id, 0).each do |account|
      threads << Thread.new { PaymentSchedule.new(account, monthly_budget) }
    end

    threads.each { |t| t.join }
    end
  end
end