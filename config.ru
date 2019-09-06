require './config/environment'
require './app/controllers/account_controller'
require './app/controllers/application_controller'

use Rack::MethodOverride

run ApplicationController
use AccountsController 