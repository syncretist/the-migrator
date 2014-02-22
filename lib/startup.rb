#!/usr/bin/env ruby

# A script to startup the dependencies for the application
# Note the files being referenced from project root, this is because this script should run in the context of the root dir in irb or pry

########################
## Load Configuration ##
########################

Dir["./config/config.rb"].each {|file| require file }

include Configuration::Debugging
include Configuration::Webapp
include Configuration::DevelopmentTools if development?

################
## Initialize ##
################

Dir["./app/controllers/**.rb"].each {|file| require file}



