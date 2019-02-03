require 'date'
require 'sinatra/flash'

class AccountsController < Sinatra::Base
  configure do
    set :views, "app/views"
    set :public_dir, "public"
  end

	get '/accounts' do
		@accounts = Account.all.to_json
		erb :accounts
	end

	post '/accounts' do
		@account = Account.new
		@account.account_name = params[:account_name]
		@account.principal = params[:principal]
		@account.due_date = params[:due_date]
		@account.apr = params[:apr]

		if @account.save
			flash[:notice] = "Account was saved."
			redirect to("/accounts/#{@account.id}")
			erb :index
		else
			flash.now[:alert] = "There was an error saving the post. Please try again."
			render :new
		end
	end

	get '/accounts/:id' do
		@current_account = Account.find(params[:id])
		@current_account.clear_payments
		@current_account.calculate_pay_schedule
		erb :index
	end

	patch '/accounts/:id' do
    @account = Account.find(params[:id])

   	@account.account_name = params[:account_name]
		@account.principal = params[:principal]
		@account.due_date = params[:due_date]
		@account.apr = params[:apr]
  
		if @account.save
			flash[:notice] = "Account was saved."
			redirect to("/accounts/#{@account.id}")
			erb :index
		else
			flash.now[:alert] = "There was an error saving the post. Please try again."
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
