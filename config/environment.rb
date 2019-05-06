configure :development do
	ENV['SINATRA_ENV'] ||= "development"
	ENV['RACK_ENV'] ||= "development"

	require 'bundler/setup'
	Bundler.require(:default, ENV['SINATRA_ENV'])
end

configure :production do
	ENV['SINATRA_ENV'] ||= "production"
	ENV['RACK_ENV'] ||= "production"

	require 'bundler/setup'
	Bundler.require(:default, ENV['SINATRA_ENV'])
end

require 'require_all'
require_all 'app'
