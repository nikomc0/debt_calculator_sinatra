require 'date'
require_relative 'application_controller'
require_relative '../services/payment_schedule'

class AccountsController < ApplicationController
	get '/accounts' do
		@accounts = Account.all
		erb :accounts
	end

	post '/accounts' do
		@account = Account.new(
			:account_name => params[:account][:account_name], 
			:principal => params[:account][:principal],
			:due_date => params[:account][:due_date], 
			:apr => params[:account][:apr]
		)

		if Account.exists?(account_name: @account[:account_name]) 
			# flash.now[:alert] = "There was an error saving the post. Please try again."
			message = "Account already exists."
			p message
			# render :new
		else
			@account.save
			# flash[:notice] = "Account was saved."
			@account.update_global_variables
			PaymentSchedule.new(@account).get_schedule
			redirect to("/accounts/#{@account.id}")
			erb :index
		end
	end

	get '/accounts/:id' do		
		@current_account = Account.find(params[:id])
		@current_account.update_global_variables
		erb :index
	end

	patch '/accounts/:id' do
  	@account = Account.find(params[:id])
  	# @payment = @account.payment.find(params[:])

 		changes = params.reject { |k, v| v.blank? || v === "PATCH"}

 		if @account.update(changes)
			# flash[:notice] = "Account was saved."
    	@account.update_global_variables
    	PaymentSchedule.new(@account).get_schedule
			redirect to("/accounts/#{@account.id}")
			erb :index
		else
			# flash.now[:alert] = "There was an error saving the post. Please try again."
			render :new
		end

 		# p @account.update(changes)
 		# p @account

  # 	if !params[:account_name].empty?
  # 		@account.account_name = params[:account_name]
  # 	end

  # 	if !params[:principal].empty?
  # 		@account.principal = params[:principal]
  # 	end
		
		# if !params[:due_date].empty?
		# 	@account.due_date = params[:due_date]
		# end

		# if !params[:apr].empty?
		# 	@account.apr = params[:apr]
		# end
  
		# if @account.save
		# 	# flash[:notice] = "Account was saved."
		# 	"something"
  #   	@account.get_global_variables
		# 	redirect to("/accounts/#{@account.id}")
		# 	erb :index
		# else
		# 	# flash.now[:alert] = "There was an error saving the post. Please try again."
		# 	render :new
		# end
  end

  patch '/accounts/:account_id/:payment_id' do
  	#  Finds the Account and its Payment that was clicked.
  	@account = Account.find(params[:account_id])
  	@payment = @account.payments.find(params[:payment_id])

  	# Updates the Accounts principal
  	@account.principal -= @payment.payment
  	@account.save

  	# Updates the payment
  	PaidPayment.create(
  		account_id: @payment.account_id,
  		payment: @payment.payment,
  		month: @payment.month
  	)

  	@payment.destroy
  end

	delete '/accounts/:id' do 
		@account = Account.find(params[:id])
		@account.delete

		redirect "/"
		erb :index
	end
end
