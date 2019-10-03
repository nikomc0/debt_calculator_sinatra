class UsersController < ApplicationController
	
	get "/create_account" do
    erb :create_account
  end

	post "/user" do
		@user = User.new(
			:first_name 			=> params[:user][:first_name],
			:last_name				=> params[:user][:last_name],
			:user_name				=> params[:user][:user_name],
			:monthly_budget		=> params[:user][:monthly_budget],
			:password					=> params[:user][:password]
		)

		if User.exists?(user_name: @user[:user_name])
			flash[:danger] = "User with #{@user[:user_name]} already exists"

			redirect "/login"
		else
			@user.save

			# Creates Session and automatically logs the user into the platform.
			warden_handler.set_user(@user)
			flash[:success] = "Your account has been created."

			redirect "/"
		end
	end

	patch "/user/:monthly_budget" do
				# ActiveRecord::Base.logger.level = 1
		@user = User.find_by(id: current_user.id)
		# @account = Account.find(params[:account_id])
		@user.monthly_budget = params[:monthly_budget]
		warden_handler.set_user(@user)
		
		@user.save

		@user.update_global_variables(current_user)
    @user.update_payment_schedule(current_user)
	end
end