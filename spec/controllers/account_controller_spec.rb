require 'json'
require 'rack/test'
require_relative '../../app/controllers/account_controller'
require_relative '../spec_helper'

RSpec.describe "AccountsController", type: :controller do
	include Rack::Test::Methods
	
	def app
		AccountsController.new
	end 

	let(:accounts) { Account.all }
	let(:current_account)  { Account.find(1) }

	describe 'get', :type => :request do
		before do
			get '/accounts'
		end

		it 'instantiates @accounts' do
			expect(:accounts).not_to be_nil
		end
	end

	describe 'POST create' do
		test_account = { :account_name => "Test Account #{Account.all.length}", :principal => 1000, :apr => 15.94, :due_date => 3 }
		duplicate = { :account_name => "Chase", :principal => 5000, :apr => 15.94, :due_date => 3 }
		
		before do
			post '/accounts', duplicate
		end

		it 'saves account to the database' do
			expect do 
				post '/accounts', test_account
			end.to change{accounts.count}.by(1)
		end

		it "checks if value already exists" do
			post '/accounts', duplicate
			expect(last_response.body).to eq("Account already exists.")
		end
	end

	describe 'GET accounts by :id' do
		before do
			get "/accounts/#{current_account.id}"
		end

		it 'responds successfully' do
			expect(last_response).to be_ok
		end

		it 'instantiates @current_account' do
			expect(current_account.account_name).to eq(Account.first.account_name)
		end
	end

	describe 'DELETE accounts by :id' do
		let!(:account)  { Account.create(account_name: "Chase", principal: 5000, apr: 15, due_date: 3) }
		it 'deletes the account' do
			expect do
				delete "/accounts/#{account.id}"
			end.to change{ accounts.count }.by(-1)
		end
	end

	describe 'PATCH accounts by :id' do
		let(:old_account) { Account.create(account_name: "Union Bank", principal: 5000, apr: 15.94, due_date: 3) }
		
		update_params = {
			:account_name => "Union",
			:principal => 2000
		}

		it 'finds the account' do
			expect(Account.find_by(account_name: "#{old_account.account_name}").account_name).to eq("Union Bank")
		end

		it 'saves the account'
	end

	describe "User sets payment to paid" do
		let(:account) {Account.last}

		it 'finds the payment' do 
			account.calculate_pay_schedule
			expect(account.payments.first).not_to be_nil
		end

		it 'sets the payment to paid'
		it 'updates principal'
	end
end