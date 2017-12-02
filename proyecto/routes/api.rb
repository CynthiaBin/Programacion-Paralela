require 'ant'
require 'jwt'
require 'yaml'
require 'json'
require 'securerandom'
require 'sinatra/base'
require_relative '../models/user'
require_relative '../models/queue'
require_relative '../models/subscription'
require_relative '../models/message'
require_relative '../helpers'

# Server
class API < Sinatra::Application
  before do
    content_type :json
  end
  post '/api/users/login' do
    not_found { status 404 } if params['user_name'].nil? || params['password'].nil?
    user_name = params['user_name']
    password = params['password']
    unless valid_name(user_name)
      return { status: false, message: 'PARAMS_INVALID' }
    end

    if User.exists?(user_name)
      user = User.by_user_name(user_name)
      if user.validate_password(password)
        config = YAML.safe_load(File.open('config/config.yml'))
        return {
          status: true,
          data: {
            token: JWT.encode(user.id, config['secret_key'], 'none')
          }
        }
      else
        return { status: false, message: 'INVALID_CREDENTIALS' }
      end
    else
      return { status: false, message: 'USER_NOT_EXISTS' }
    end
  end

  post '/api/users/user' do
    not_found { status 404 } if params['user_name'].nil? || params['password'].nil?
    user_name = params['user_name']
    password = params['password']
    unless valid_name(user_name)
      return { status: false, message: 'PARAMS_INVALID' }
    end

    if User.exists?(user_name)
      return { status: false, message: 'USER_EXISTS' }
    else
      user = User.new(user_name, password)
      id = user.register
      config = YAML.safe_load(File.open('config/config.yml'))
      return {
        status: true,
        data: {
          token: JWT.encode(user.id, config['secret_key'], 'none')
        }
      }
    end
  end

  put '/api/users/password' do
    not_found { status 404 } if params['token'].nil? ||
                                params['new_password'].nil?
    token = params['token']
    new_password = params['new_password']

    id = decode_id(token)
    return { status: false, message: 'INVALID_CREDENTIALS' } if id == -1

    user = User.by_id(id)
    user.change_password(new_password)
    return {
      status: true
    }
  end

  post '/api/chats/chat' do
    not_found { status 404 } if params['token'].nil? ||
                                params['user'].nil?
    token = params['token']
    user_n = params['user']

    id = decode_id(token)
    return { status: false, message: 'INVALID_CREDENTIALS' } if id == -1

    user = User.by_id(id)

    return { status: false, message: 'SAME_USER' } if user_n == user.user_name
    return { status: false, message: 'NOT_EXISTS_USER' }  unless User.exists?(user_n)

    user_two = User.by_user_name(user_n)

    queue_ = MQueue.new(SecureRandom.uuid)
    q_id = queue_.register
    susbscription_one = Subscription.new(user.id, q_id)
    susbscription_one.register
    susbscription_two = Subscription.new(user_two.id, q_id)
    susbscription_two.register

    return {
      status: true,
      data: { id: queue_.id, name: queue_.name }
    }
  end

  post '/api/chats/superchat' do
    not_found { status 404 } if params['token'].nil? ||
                                params['users'].nil? ||
                                params['name'].nil?
    token = params['token']
    name = params['name']
    users = params['users']

    id = decode_id(token)
    return { status: false, message: 'INVALID_CREDENTIALS' } if id == -1

    user = User.by_id(id)

    return { status: false, message: 'CHAT_NAME_EXISTS' } if MQueue.exists?(name)
    user_names = []
    users.split(',').each do |user_n|
      user_n = user_n.strip
      return { status: false, message: 'NOT_EXISTS_USER' } unless User.exists?(user_n)
      user_names.push(user_n)
    end

    queue_ = MQueue.new(name)
    q_id = queue_.register
    susbs = Subscription.new(user.id, q_id)
    susbs.register
    user_names.each do |user_n|
      susbs = Subscription.new(User.by_user_name(user_n).id, q_id)
      susbs.register
    end
    return {
      status: true,
      data: { id: queue_.id, name: queue_.name }
    }
  end

  put '/api/chats/superchat/:name' do
    not_found { status 404 } if params['token'].nil? ||
                                params['user'].nil? ||
                                params['name'].nil?
    token = params['token']
    name = params['name']
    user_n = params['user']

    id = decode_id(token)
    return { status: false, message: 'INVALID_CREDENTIALS' } if id == -1
    return { status: false, message: 'CHAT_NAME_NOT_EXISTS' } unless MQueue.exists?(name)
    return { status: false, message: 'NOT_EXISTS_USER' } unless User.exists?(user_n)

    user = User.by_user_name(user_n)
    queue_ = MQueue.by_name(name)
    return { status: false, message: 'PREVIOUS_ADDED' } if Subscription.exists_user?(user.id, queue_.id)

    susbs = Subscription.new(user.id, queue_.id)
    susbs.register

    return {
      status: true,
      data: { msg: 'Added', id: queue_.id, name: queue_.name }
    }
  end

  delete '/api/chats/superchat/:name' do
    not_found { status 404 } if params['token'].nil? ||
                                params['user'].nil? ||
                                params['name'].nil?
    token = params['token']
    name = params['name']
    user_n = params['user']

    id = decode_id(token)
    return { status: false, message: 'INVALID_CREDENTIALS' } if id == -1
    return { status: false, message: 'CHAT_NAME_NOT_EXISTS' } unless MQueue.exists?(name)
    return { status: false, message: 'NOT_EXISTS_USER' } unless User.exists?(user_n)

    user = User.by_user_name(user_n)
    queue_ = MQueue.by_name(name)
    return { status: false, message: 'NOT_MEMBER' } unless Subscription.exists_user?(user.id, queue_.id)

    Subscription.delete(user.id, queue_.id)

    return {
      status: true,
      data: { msg: 'Deleted', id: queue_.id, name: queue_.name }
    }
  end

  get '/api/chats' do
    not_found { status 404 } if params['token'].nil?
    token = params['token']

    id = decode_id(token)
    return { status: false, message: 'INVALID_CREDENTIALS' } if id == -1

    user = User.by_id(id)

    return {
      status: true,
      data: MQueue.list_by_user_id(user.id)
    }
  end

  post '/api/chats/:name/message' do
    not_found { status 404 } if params['token'].nil? ||
                                params['content'].nil? ||
                                params['name'].nil?
    token = params['token']
    name = params['name']
    content = params['content']

    id = decode_id(token)
    return { status: false, message: 'INVALID_CREDENTIALS' } if id == -1
    return { status: false, message: 'CHAT_NAME_NOT_EXISTS' } unless MQueue.exists?(name)

    user = User.by_id(id)
    queue_ = MQueue.by_name(name)

    return { status: false, message: 'NOT_MEMBER' } unless Subscription.exists_user?(user.id, queue_.id)

    message = Message.new(content, user.id, queue_.id)
    message.register

    return {
      status: true,
      data: { msg: message.content, id: queue_.id, name: queue_.name }
    }
  end

  get '/api/chats/:name/messages' do
    not_found { status 404 } if params['token'].nil? ||
                                params['name'].nil?
    token = params['token']
    name = params['name']

    id = decode_id(token)
    return { status: false, message: 'INVALID_CREDENTIALS' } if id == -1
    return { status: false, message: 'CHAT_NAME_NOT_EXISTS' } unless MQueue.exists?(name)

    user = User.by_id(id)
    queue_ = MQueue.by_name(name)

    return { status: false, message: 'NOT_MEMBER' } unless Subscription.exists_user?(user.id, queue_.id)

    page = params['page'].nil? ? 1 : params['page'].to_i
    messages = Message.list_by_queue(queue_.id, page)

    return {
      status: true,
      data: messages
    }
  end

  after do
    response.body = JSON.dump(response.body)
  end
end
