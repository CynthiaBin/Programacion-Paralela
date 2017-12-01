require 'grape'
require 'json'
require 'ant'
require_relative 'routes/app'

# Class AuthServer
class FileServer < Grape::API
  version 'v0', using: :header, vendor: 'PP'
  format :json
  prefix :api

  helpers Ant::Response

  mount Routes::API
end
