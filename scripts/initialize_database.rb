#! /usr/bin/ruby

#
# This script initialize the database by creating the necessary tables and fields
#
print "Initializing database..."

begin
  require 'yaml'
  require 'sequel'

  # load the config file
  CONFIG =  YAML.load_file('./config.yml')

  # Connecting to the database
  case CONFIG['database']['adapter']
  when "sqlite3"
    DB = Sequel.connect("sqlite://#{Dir.pwd}/#{CONFIG['database']['database']}")
  when "mysql"
    DB = Sequel.connect("mysql://#{CONFIG['database']['user']}:#{CONFIG['database']['password']}@#{CONFIG['database']['server']}/#{CONFIG['database']['database']}")
  when "postgres"
    DB = Sequel.connect("postgres://#{CONFIG['database']['user']}:#{CONFIG['database']['password']}@#{CONFIG['database']['server']}/#{CONFIG['database']['database']}")
  when "memory"
    DB = Sequel.sqlite
  end

  # Create the tables & fields
  DB.create_table :domains do
     primary_key :id
    String :name
  end

  DB.create_table :users do
    primary_key :id
    String :mail
    Text :password
  end

  DB.create_table :aliases do
    primary_key :id
    String :source
    String :destination
  end

  puts "OK!"
rescue => e
  puts "Failure!"
  puts "Error during database initialization :"
  puts e
end
