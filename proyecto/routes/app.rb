require 'grape'
require 'json'
require 'ant'
require 'awesome_print'

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
          site = Site.new(name, url)
          site.register
        end
      end

      # /api/sites/:site
      route_param :site do
        # get /api/sites/:site
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
          site = params[:site]
          process_request do
            valid_name(site)
            valid_name(params[:user])
            register = Register.new(params[:user],
                                    site,
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
          valid_name(params[:name])
          queue = MQueue.new(params[:name])
          queue.register
        end
      end
    end

    route_param :queue do
      # POST /api/:queue
      post do
        queue_name = params[:queue]
        process_request do
          valid_name(queue_name)

          message_id = MessageAdmin.new_message(params[:content], queue_name)
          message = MessageAdmin.link_new_message(queue_name, message_id)
          {
            id: message.id,
            content: message.content,
            created_at: message.created_at
          }
        end
      end

      # POST /api/:queue/subscribe
      post :subscribe do
        queue_name = params[:queue]
        process_request do
          subscriber = params[:subscriber]
          valid_name(queue_name)
          valid_name(subscriber)
          register = Register.new(subscriber)
          register.register_in_queue(queue_name)
          messages = MessageAdmin.messages_by_queue(queue_name)
          MessageAdmin.link_messages(subscriber, messages, queue_name)
          {
            old_messages: messages
          }
        end
      end

      # POST /api/:queue/purge
      post :purge do
        queue_name = params[:queue]
        process_request do
          subscriber = params[:subscriber]
          valid_name(queue_name)
          valid_name(subscriber)

          MessageAdmin.purge(subscriber, queue_name)

        end
      end

      route_param :subscriber do
        # POST /api/:queue/:subscriber
        get do
          subscriber = params[:subscriber]
          queue_name = params[:queue]
          process_request do
            valid_name(subscriber)
            valid_name(queue_name)
            message = MessageAdmin.next_message(subscriber, queue_name)
            if !message.nil?
              {
                id: message.id,
                content: message.content,
                created_at: message.created_at
              }
            else
              {
                content: ''
              }
            end
          end
        end
      end
    end
  end
end
