module Configuration
  module Debugging
    require 'pry-debugger' # allows use of binding.pry (via STDOUT) throughout without explicit reference
    require 'pry-remote'   # allows use of binding.pry (via `pry-remote` command in bundle at webapp server) throughout without explicit reference
  end
  module Webapp
    require 'sinatra'
  end
  module Database
    require 'dm-core'
    require 'dm-migrations'
    require 'dm-timestamps' # http://datamapper.org/docs/dm_more/timestamps.html
    require 'dm-types' # http://datamapper.org/docs/dm_more/types.html
    require 'json'
  end
  module RenderingEngines
    require 'slim'
  end
  module CssTools
    require 'sass'
  end
  module DevelopmentTools
    require 'sinatra/reloader'
  end
end