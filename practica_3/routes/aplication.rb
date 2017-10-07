require 'grape'
require 'json'
require 'ant'

require_relative '../models/abstract_base'
require_relative '../models/authentication'
require_relative '../models/site'
require_relative '../models/user'
module Routes
  # Router class
  class Aplication < Grape::API

    resource :sites do
      # get /api/sites
      get do
        site = Site.new('empty', 'empty')
        site.list_all
      end

      # post /api/sites
      post do
        process_request do
          name = params[:name]
          url = params[:url]

          site = Site.new(name, url)
          site.register
        end
      end

      # /api/sites/site
      route_param :site do
        # get /api/sites/site
        get :users do
          all = Site.new(params[:site], 'Empty')
          all.users_in_site
        end

        post :auth do
          process_request do
            user = params[:user]
            pass = params[:pass]
            site = params[:site]
            auth = Controller::Auth.new(site, user, pass)
            auth.validate
          end
        end
      end
    end
  end
end
