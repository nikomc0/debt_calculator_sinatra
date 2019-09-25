require './config/environment'
require './app/controllers/account_controller'
require './app/controllers/application_controller'

	use Rack::MethodOverride
	use Rack::Session::Cookie, :key => 'DC.overide',
  	                         :path => '/',
    	                       :secret => 'supersupe'

use AccountsController 
run ApplicationController
