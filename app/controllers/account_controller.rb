require 'date'
require_relative 'application_controller'
require_relative '../services/payment_schedule'

class AccountsController < ApplicationController
	# configure do
	# 	enable :sessions
	# end

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
			flash.now[:danger] = "There was an error saving the post. Please try again."
			# render :new
		else
			@account.save
			flash[:success] = "Account was saved."
			@account.update_global_variables
			@account.update_payment_schedule

			redirect to("/accounts/#{@account.id}")
			erb :index
		end
	end

	get '/accounts/:id' do		
		# ActiveRecord::Base.logger.level = 1
		@current_account = Account.find(params[:id])
		@current_account.update_global_variables

		erb :index
	end

	patch '/accounts/:id' do
  	@account = Account.find(params[:id])
  	# @payment = @account.payment.find(params[:])

 		changes = params.reject { |k, v| v.blank? || v === "PATCH"}

 		if @account.update(changes)
			flash[:success] = "Account was saved."
    	@account.update_global_variables
    	@account.update_payment_schedule

			redirect to("/accounts/#{@account.id}")
			erb :index
		else
			# flash.now[:alert] = "There was an error saving the post. Please try again."
			render :new
		end
  end

  patch '/accounts/:account_id/:payment_id' do
  	# ActiveRecord::Base.logger.level = 1
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
  	flash[:success] = "Payment has been saved."
  	redirect "/accounts/#{params[:account_id]}"
  end

	delete '/accounts/:id' do 
		@account = Account.find(params[:id])
		@account.delete

		redirect "/"
		erb :index
	end
end
