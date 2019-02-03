require "sinatra"
require 'sinatra/activerecord'
require 'sinatra/flash'

class ApplicationController < Sinatra::Application

  configure do
    set :views, "app/views"
    set :public_dir, "public"
  end

  get 'https://safe-wildwood-85428.herokuapp.com/' do
    $total_accounts
    $total_balance
    $total_debt
    erb :index
  end

  get '/info' do
    erb :index
  end
end
