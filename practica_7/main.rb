require 'grape'
require 'json'
require 'ant'

require_relative 'routes/aplication'

# Class AuthServer
class AuthServer < Grape::API
  version 'v0', using: :header, vendor: 'PP'
  format :json
  prefix :api

  helpers Ant::Response

  mount Routes::Aplication
end
