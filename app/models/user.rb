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
end