require 'grape'
require 'json'
require 'ant'

require_relative '../models/abstract_base'
require_relative '../models/authentication'
require_relative '../models/site'
require_relative '../models/user'
require_relative '../controllers/auth'
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

      # /api/sites/:site
      route_param :site do
        # get /api/sites/site
        get :users do
          all = Site.new(params[:site])
          all.users_in_site
        end

        # get /api/sites/:site/auth
        post :auth do
          site = params[:site]
          puts site
          process_request do
            puts params
            auth = Auth.new(params[:user], site, params[:password])
            puts auth
            auth.validate
          end
        end

        post :register do
          process_request do
            site = params[:site]
            user_name = params 
          end
        end
      end
    end
  end
end
