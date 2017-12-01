require 'json'
require 'sinatra/base'

# Server
class Indexer < Sinatra::Application
  attr_reader :server_name
  attr_reader :sinatra

  get '/indexer/' do
    ap "Yiei"
  end
end
