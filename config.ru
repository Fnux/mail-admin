puts "**********************************"
puts "[Mail-admin] Starting Web App..."

# load dependencies
require 'rubygems'
require 'sinatra'
require 'sinatra/namespace'
require 'yaml'
require 'sequel'

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
    DB = Sequel.connect("sqlite://#{Dir.pwd}/#{CONFIG['database']['database']}")
when "mysql"
    DB = Sequel.connect("mysql://#{CONFIG['database']['user']}:#{CONFIG['database']['password']}@#{CONFIG['database']['server']}/#{CONFIG['database']['database']}")
when "postgres"
    DB = Sequel.connect("postgres://#{CONFIG['database']['user']}:#{CONFIG['database']['password']}@#{CONFIG['database']['server']}/#{CONFIG['database']['database']}")
end

# Set views directory
set :views, settings.root + '/views'

# Render ERB files using ".html.erb" extensions (instead of ".erb")
Tilt.register Tilt::ERBTemplate, 'html.erb'

# Load the application (app.rb)
require File.expand_path '../app.rb', __FILE__

# Let's run this app :3
run MailAdmin
