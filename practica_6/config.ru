require 'rack'
require 'rack/cascade.rb'
require_relative 'daemon'
require_relative 'main'

daemon = Daemon.new
daemon.run
run Rack::Cascade.new [Routes::API.new]
