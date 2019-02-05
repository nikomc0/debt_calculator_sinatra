require "sinatra"
require 'sinatra/activerecord'
# require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  # enable :sessions
  # register Sinatra::Flash
  
  configure do
    set :views, "app/views"
    set :public_dir, "public"
  end

  get '/' do
    erb :index
  end

  get '/info' do
    erb :index
  end
end
