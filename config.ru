require 'rubygems'
require 'sinatra'
require 'sinatra/namespace'
require "sinatra/reloader" if development?
require 'yaml'
require 'sequel'

# Config
CONFIG =  YAML.load_file('config.yml')

# Enable sessions
use Rack::Session::Cookie, :key => 'session',
  :path => '/',
  :expire_after => 3600,
  :secret => CONFIG['secret']

# Database
adapter = CONFIG['database']['adapter']
if adapter == "sqlite3"
  DB = Sequel.connect("sqlite://#{Dir.pwd}/#{CONFIG['database']['database']}")
else
  DB = Sequel.connect(:adapter => adapter,
                      :host => CONFIG['database']['server'], 
                      :database => CONFIG['database']['database'],
                      :user => CONFIG['database']['user'],
                      :pasword => CONFIG['database']['password'])
end

# Set views directory
set :views, settings.root + '/views'

# Render ERB files using ".html.erb" extensions (instead of ".erb")
Tilt.register Tilt::ERBTemplate, 'html.erb'

# Load the application (app.rb)
require File.expand_path '../app.rb', __FILE__

# Run
run MailAdmin
