# ENV['SINATRA_ENV'] ||= "development"
# ENV['RACK_ENV'] ||= "development"

# require 'bundler/setup'
# Bundler.require(:default, ENV['SINATRA_ENV'])

# require 'require_all'
# require_all 'app'

configure :production, :development do
db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/bucket_dev')
ActiveRecord::Base.establish_connection(
  adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  host: db.host,
  username: db.user,
  password: db.password,
  database: db.path[1..-1],
  encoding: 'utf8'
)
end
