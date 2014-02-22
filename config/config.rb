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