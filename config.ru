puts "**********************************"
puts "[Mail-admin] Starting Web App..."

# load dependencies
require 'rubygems'
require 'sinatra'
require "yaml"
require 'data_mapper'
#require 'digest/sha2'

# load the config file
CONFIG =  YAML.load_file('config.yml')

# if "reloader: true"
require "sinatra/reloader" if CONFIG['reloader']

# Enable sessions
use Rack::Session::Cookie, :key => 'session',
                           :path => '/',
                           :expire_after => 3600, # In seconds
                           :secret => CONFIG['secret']

# Connecting to the database

case CONFIG['database']['adapter']
when "sqlite3"
   adapter = DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/#{CONFIG['database']['database']}")
when "mysql"
   adapter = DataMapper::setup(:default,
   "mysql://#{CONFIG['database']['user']}:#{CONFIG['database']['password']}
   @#{CONFIG['database']['server']}/#{CONFIG['database']['database']}")
when "postgres"
   adapter = DataMapper::setup(:default, "postgres://#{CONFIG['database']['user']}:#{CONFIG['database']['password']}
   @#{CONFIG['database']['server']}/#{CONFIG['database']['database']}")
end
adapter.resource_naming_convention = DataMapper::NamingConventions::Resource::UnderscoredAndPluralizedWithoutModule

# Set views directory
set :views, settings.root + '/views'

# Render ERB files using ".html.erb" extensions (instead of ".erb")
Tilt.register Tilt::ERBTemplate, 'html.erb'

# Load the application (app.rb)
require File.expand_path '../app.rb', __FILE__

# Let's run this app :3
run MailAdmin
