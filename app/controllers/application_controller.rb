require "sinatra"
require "sinatra/flash"
require "warden"

class ApplicationController < Sinatra::Base
  
  configure do
    set :views, "app/views"
    set :public_dir, "public"
    register Sinatra::Flash
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

    flash[:success] = "Successfully logged in"

    if warden_handler.authenticated?
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
    redirect '/'
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
        fail!("Could not log in")
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
end
