require 'bundler/setup'
Bundler.require

configure :development do
	ENV['SINATRA_ENV'] ||= "development"
	ENV['RACK_ENV'] ||= "development"

	require 'bundler/setup'
	Bundler.require(:default, ENV['SINATRA_ENV'])

end

require 'require_all'
Bundler.require(:default, ENV['SINATRA_ENV'])

require_all 'app'