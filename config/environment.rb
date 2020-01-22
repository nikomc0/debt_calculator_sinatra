ENV['SINATRA_ENV'] ||= "development"
ENV['RACK_ENV'] ||= "production"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require 'require_all'
require_all 'app'
