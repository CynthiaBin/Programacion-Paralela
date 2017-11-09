require 'grape'
require 'json'
require 'ant'

require_relative '../models/abstract_base'
require_relative '../models/message'
require_relative '../models/queue'
require_relative '../models/subscription'
require_relative '../models/message_status'
require_relative '../models/site'
require_relative '../models/user'
require_relative '../controllers/message_admin'
require_relative '../controllers/register'
require_relative '../controllers/auth'
require_relative '../controllers/register'
require_relative '../helpers'

module Routes

  # Aplication
  class App < Grape::API
    resource :sites do
      # get /api/sites
      get do
        site = Site.new
        site.list_all
      end

      # post /api/sites
      post do
        process_request do
          valid_name(params[:name])
          name = params[:name]
          url = params[:url]
          puts params[:name]
          puts params[:url]
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
            puts params[:user]
            puts params[:site]
            puts params[:password]
            register = Register.new(params[:user],
                                    params[:site],
                                    params[:password])
            register.register_in_site
          end
        end
      end 
    end

    resource :queues do
      # GET /api/queues
      get do
        queue = MQueue.new
        queue.list_all
      end

      # POST /api/queues
      post do
        process_request do
          queue = MQueue.new(params[:queue])
          queue.register
        end
      end
    end
   

    route_param :queue do
      # POST /api/:queue
      post do
        process_request do
          message_admin = MessageAdmin.new
          id = message_admin.new_message(params[:text], params[:queue])
          message_admin.link_new_message(params[:queue], id)
        end
      end

      # POST /api/:queue/subscribe
      post :subscribe do
        process_request do
          register = Register.new(params[:subscriber])
          register.register_in_queue(params[:subscriber], params[:queue])
          message_admin = MessageAdmin.new
          messages = message_admin.messages_by_queue(params[:queue])
          message_admin.link_messages(params[:subscriber], messages, params[:queue])
        end
      end
    end
  end
end
