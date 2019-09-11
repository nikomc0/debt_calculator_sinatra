require "sinatra"
# require 'sinatra/activerecord'
# require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  # enable :sessions
  # register Sinatra::Flash

  configure do
    set :views, "app/views"
    set :public_dir, "public"
  end

  # Main Dashboard Info
  get '/' do
    $total_accounts = Account.all.length
    $accounts = Account.all
    $total_debt = Account.sum(:principal)
    erb :index
  end

  # get '/info' do
  #   erb :index
  # end
end
