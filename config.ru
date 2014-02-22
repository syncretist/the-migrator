# Rack configuration
# http://www.sinatrarb.com/intro.html#Using%20a%20Classic%20Style%20Application%20with%20a%20config.ru
# https://github.com/rack/rack/wiki/(tutorial)-rackup-howto

require './lib/startup.rb'

run Sinatra::Application

# Environment specific actions
# http://stackoverflow.com/questions/5832060/sinatra-configuring-environments-on-the-fly

configure(:production ){ p "PRODUCTION MODE"  }
configure(:development){ p "DEVELOPMENT MODE" }
configure(:staging    ){ p "STAGING MODE"     }

# cd <project root>/
# Usage: `rackup` [ruby options] [rack options] [rackup config]
#
# Ruby options:
# -e, --eval LINE          evaluate a LINE of code
# -b BUILDER_LINE,         evaluate a BUILDER_LINE of code as a builder script
#    --builder
# -d, --debug              set debugging flags (set $DEBUG to true)
# -w, --warn               turn warnings on for your script
# -I, --include PATH       specify $LOAD_PATH (may be used more than once)
# -r, --require LIBRARY    require the library, before executing your script
#
# Rack options:
# -s, --server SERVER      serve using SERVER (thin/puma/webrick/mongrel)
# -o, --host HOST          listen on HOST (default: 0.0.0.0)
# -p, --port PORT          use PORT (default: 9292)
# -O NAME[=VALUE],         pass VALUE to the server as option NAME. If no VALUE, sets it to true. Run '/home/qa-eric/.rvm/gems/ruby-1.9.3-p0@the-migrator/bin/rackup -s SERVER -h' to get a list of options for SERVER
#    --option
# -E, --env ENVIRONMENT    use ENVIRONMENT for defaults (default: development)
# -D, --daemonize          run daemonized in the background
# -P, --pid FILE           file to store PID (default: rack.pid)
#
# Common options:
# -h, -?, --help           Show this message
# --version                Show version
