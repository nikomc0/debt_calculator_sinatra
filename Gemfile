source "https://rubygems.org"

gem 'sinatra'
gem 'sinatra-activerecord'
gem 'activerecord', '~> 5.0', :require => 'active_record'
gem 'sinatra-flash'
gem 'rake'
gem 'require_all'

 group :production do
 	gem 'pg'
 end

 group :test do
 	gem 'rspec'	
 	gem 'coderay'
	gem 'guard'
	gem 'guard-rspec'
	gem 'rack-test'
	gem 'database_cleaner'
	gem 'capybara'
	gem 'fuubar'
 end

 group :test, :development do
	gem 'shotgun'
	gem 'pry'
	gem 'pry-remote'
	gem 'tux'
	gem 'byebug', "~> 10.0"
 end
