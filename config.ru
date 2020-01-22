require './config/environment'
require './app/workers/big_job'
require './app/controllers/account_controller'
require './app/controllers/user_controller'
require './app/controllers/application_controller'
# require 'sidekiq/web'

	use Rack::MethodOverride
	use Rack::Session::Cookie, :key => 'DC.overide',
  	                         :path => '/',
    	                       :secret => 'supersupe'

	# Sidekiq::Web.set :sessions, false

use AccountsController 
use UsersController
run ApplicationController

# run Rack::URLMap.new('/' => BigJob, '/sidekiq' => Sidekiq::Web)
