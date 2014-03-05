#!/usr/bin/env ruby

# A script to startup the dependencies for the application
# Note the files being referenced from project root, this is because this script should run in the context of the root dir in irb or pry

########################
## Load Configuration ##
########################

Dir["./config/config.rb"].each {|file| require file }

include Configuration::Debugging
include Configuration::Webapp
include Configuration::Database
include Configuration::RenderingEngines
include Configuration::DevelopmentTools if development?

######################
## Sinatra Settings ##
######################

# http://www.sinatrarb.com/configuration.html
# Code inside `configure` blocks is run only once at startup

puts ""
puts "Sinatra Settings (set via #{__FILE__}):"
puts "----------------"

## Paths

configure :production do
  root_path = Dir['./app']

  set :root, root_path
  puts "  * This sinatra applications project root is #{root_path}."

  set :public_folder  , 'app/public'
  set :views          , 'app'
end

configure :development do
  root_path = Dir['./app']

  set :root, root_path
  puts "  * This sinatra applications project root is #{root_path}."

  set :public_folder  , 'app/public'
  set :views          , 'app'
end

configure :example do
  root_path = Dir['./doc/example-app']

  set :root, root_path
  puts "  * This sinatra applications project root is #{root_path}."

  set :public_folder  , 'doc/example-app/public'
  set :views          , 'doc/example-app'
end

## Logging
##
## http://stackoverflow.com/questions/1633431/having-trouble-debugging-sinatra-app-in-production

configure :production do
  set :raise_errors => true
  set :logging, true

  log = File.new("log/sinatra.log", "a+")
  STDOUT.reopen(log)
  STDERR.reopen(log)

  require 'logger'
  configure do
    LOGGER = Logger.new("log/sinatra.log")
  end

  helpers do
    def logger
      LOGGER
    end
  end
end

## Custom Settings
##
##   * It’s also possible to create your own custom settings in Sinatra. These can be used
##     for application-wide variables and are stored in the settings object. Custom settings
##     can be easily created using the set method.
##
##   * We can even create dynamic settings using a block: set(:image_folder){ :root + '/images' }
##     This will append /images at the end of the path to the root folder, and will update if the root folder changes.
##
##   * Settings that can only have Boolean true or false values can also be set using enable and disable for better readability

set :project_maintainer_email, "eglassman@scitent.com" # settings.project_maintainer_email

## Sessions
##
## Sinatra uses cookie-based sessions by default, so small amounts of information
## can be stored in a session cookie on the user’s machine; this information is
## then accessible via the session hash. Session cookies are destroyed when a user’s
## session finishes by closing the browser, so the information only persists for this duration.

#TODO what happens if new session secret is used each time it is started up... will this screw with users... should it be persisted in the db somehow with encryption?

class SecretCreator
  require 'digest/md5'

  def self.create_secret(string)
    Digest::MD5.hexdigest(string)
  end
end

configure { enable :sessions }
set :session_secret, SecretCreator.create_secret("Who is your daddy and what does he do?\n")

## Informative messaging

configure :development, :example do
  puts ""

  puts "You can create external tunnels when developing locally using `localtunnel <port>`"
  puts "More info here: http://progrium.com/localtunnel/"
  puts ""
end

## Environment messaging
## http://stackoverflow.com/questions/5832060/sinatra-configuring-environments-on-the-fly

configure(:production ){ p "PRODUCTION MODE"  }
configure(:development){ p "DEVELOPMENT MODE" }
configure(:staging    ){ p "STAGING MODE"     }
configure(:example    ){ p "EXAMPLE MODE"     }

puts ""

################
## Initialize ##
################

configure :development, :staging, :production do
  Dir["./app/routers/**.rb"].each {|file| require file} # be careful with order of load here, if there are similar routes, the first loaded will take precedence
  Dir["./app/models/**.rb"].each {|file| require file}
end


configure :example do
  Dir["./doc/example-app/routers/**.rb"].each {|file| require file}
  Dir["./doc/example-app/models/**.rb"].each {|file| require file}
end

####################
## Database Setup ##
####################

# if the db isnt finding tables the models may need `<Model>.auto_migrate!` run by placing binding.pry at the end of the db config block... find better way through rake etc...
# make sure these migrations dont clobber existing tables!

configure :production do
  # ENV is a hash-like accessor for environment variables.
  # http://ruby-doc.org/core-1.9.3/ENV.html

  #DataMapper.setup(:default, ENV['DATABASE_URL']) if ENV['DATABASE_URL']
  DataMapper.setup(:default, "mysql://#{THE_MIGRATOR_PRODUCTION_DATABASE[:username]}:#{THE_MIGRATOR_PRODUCTION_DATABASE[:password]}@#{THE_MIGRATOR_PRODUCTION_DATABASE[:host]}/#{THE_MIGRATOR_PRODUCTION_DATABASE[:database]}")
  DataMapper.finalize # required after all classes using DataMapper to check their integrity. It needs to be called before the app starts interacting with any classes.
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

  DataMapper.finalize # required after all classes using DataMapper to check their integrity. It needs to be called before the app starts interacting with any classes.
end

configure :example do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/example.db")
  DataMapper.finalize # required after all classes using DataMapper to check their integrity. It needs to be called before the app starts interacting with any classes.
end





