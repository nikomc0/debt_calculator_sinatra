require "sinatra"
require "sinatra/flash"
require "warden"
require 'sinatra/cross_origin'

class ApplicationController < Sinatra::Base
  
  configure do
    set :views, "app/views"
    set :public_dir, "public"
    register Sinatra::Flash
    register Sinatra::CrossOrigin
    enable :logging
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, PATCH, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "https://safe-wildwood-85428.herokuapp.com"
    200
  end

  # Main Dashboard Info
  get '/' do
    check_authentication
    $total_accounts = current_user.accounts.all.length
    $accounts = current_user.accounts.all
    $total_debt = current_user.accounts.sum(:principal)
    $monthly_budget = current_user.monthly_budget

    erb :index
  end

  get "/login" do
    erb '/login'.to_sym
  end

  post "/session" do
    warden_handler.authenticate!

    if warden_handler.authenticated?
      flash[:success] = "Successfully logged in"
      redirect "/" 
    else
      redirect "/login"
    end
  end

  get "/logout" do
    warden_handler.logout
    redirect '/login'
  end

  post "/unauthenticated" do
    flash[:danger] = warden_handler.message unless warden_handler.message.blank?
    redirect '/login'
  end

  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = ApplicationController
  end

  Warden::Manager.serialize_into_session{ |user| user.id }
  Warden::Manager.serialize_from_session{ |id| User.find(id) }

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user_name'] && params['password']
    end

    def authenticate!
      user = User.find_by(user_name: params["user_name"])
      
      if user && user.authenticate(params["password"])
        success!(user)
      else
        fail!("Username or Password incorrect.")
      end
    end
  end

  def warden_handler
    env['warden']
  end

  def current_user
    warden_handler.user
  end

  def check_authentication
    redirect '/login' unless warden_handler.authenticated?
  end

  def unauthenticated 
    flash[:danger] = warden_handler.message unless warden_handler.message.blank?
  end
end
