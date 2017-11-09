require 'rack'
require 'rack/cascade.rb'
require_relative 'main'

run Rack::Cascade.new [Routes::App.new]
