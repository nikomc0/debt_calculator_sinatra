require 'date'
require "sinatra"
require 'sinatra/activerecord'
# require 'sinatra/flash'

class AccountsController < Sinatra::Base
	# enable :sessions
 #  register Sinatra::Flash

  configure do
    set :views, "app/views"
    set :public_dir, "public"
  end

	get '/accounts' do
		@accounts = Account.all
		# erb :accounts
	end

	post '/accounts' do
		@account = Account.new
		@account.account_name = params[:account_name]
		@account.principal = params[:principal]
		@account.due_date = params[:due_date]
		@account.apr = params[:apr]

		if Account.exists?(account_name: @account.account_name) 
			# flash.now[:alert] = "There was an error saving the post. Please try again."
			message = "Account already exists."
			# render :new
		else
			@account.save
			# flash[:notice] = "Account was saved."
			@account.get_global_variables
			redirect to("/accounts/#{@account.id}")
			erb :index
		end
	end

	get '/accounts/:id' do
		@current_account = Account.find(params[:id])
		@current_account.get_global_variables
		@current_account.clear_payments
		@current_account.calculate_pay_schedule
		@current_account.account_name
		erb :index
	end

	patch '/accounts/:id' do
  	@account = Account.find(params[:id])
  	if !params[:account_name].empty?
  		@account.account_name = params[:account_name]
  	end

  	if !params[:principal].empty?
  		@account.principal = params[:principal]
  	end
		
		if !params[:due_date].empty?
			@account.due_date = params[:due_date]
		end

		if !params[:apr].empty?
			@account.apr = params[:apr]
		end
  
		if @account.save
			# flash[:notice] = "Account was saved."
			"something"
    	@account.get_global_variables
			redirect to("/accounts/#{@account.id}")
			erb :index
		else
			# flash.now[:alert] = "There was an error saving the post. Please try again."
			render :new
		end
  end

	delete '/accounts/:id' do 
		@account = Account.find(params[:id])
		@account.delete

		redirect "/"
		erb :index
	end
end
