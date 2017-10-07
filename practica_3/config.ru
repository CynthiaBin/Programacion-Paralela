require 'rack'
require 'rack/cascade.rb'
require_relative 'main'

run Rack::Cascade.new [Routes::Aplication.new]
