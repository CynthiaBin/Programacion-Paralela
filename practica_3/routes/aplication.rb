require 'grape'
require 'json'
require 'ant'

require_relative '../models/abstract_base'
require_relative '../models/authentication'
require_relative '../models/site'
require_relative '../models/user'
require_relative '../controllers/auth'
require_relative '../controllers/register'
require_relative '../helpers'
module Routes
  # Router class
  class Aplication < Grape::API
    resource :sites do
      # get /api/sites
      get do
        site = Site.new()
        site.list_all
      end

      # post /api/sites
      post do
        process_request do
          valid_name(params[:name])
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
          valid_name(params[:site])
          all = Site.new(params[:site])
          all.users_in_site
        end

        # get /api/sites/:site/auth
        post :auth do
          site = params[:site]
          process_request do
            valid_name(site)
            valid_name(params[:user])
            auth = Auth.new(params[:user], site, params[:password])
            auth.validate
          end
        end

        # POST /api/sites/:site/register
        post :register do
          process_request do
            valid_name(params[:site])
            valid_name(params[:user])
            site = params[:site]
            user_name = params[:user]
            password = params[:password]
            register = Register.new(user_name, site, password)
            register.register_in_site
          end
        end
      end
    end
  end
end
