ENV['SINATRA_ENV'] = "test"
ENV['RACK_ENV'] = "test"

require 'bundler/setup'
require 'require_all'
Bundler.require(:default, ENV['SINATRA_ENV'])

require_all 'app'