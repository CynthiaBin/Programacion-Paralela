require 'awesome_print'
require 'rack'
require 'rack/cascade.rb'
require_relative 'daemon'
require_relative 'routes/server'
require_relative 'routes/indexer'

daemon = Daemon.new
daemon.run

run Rack::Cascade.new [Server.new, Indexer.new]
