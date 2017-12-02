require 'ant'
require 'jwt'
require 'yaml'
require 'json'
require 'sinatra/base'
require_relative '../models/user'
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
    unless valid_name(user_name) || valid_name(password)
      return { status: false, message: 'PARAMS_INVALID' }
    end

    if User.exists?(user_name)
      user = User.by_user_name(user_name)
      if user.validate_password(password)
        config = YAML.safe_load(File.open('config/config.yml'))
        return {
          status: true,
          data: {
            token: JWT.encode(user.id, config['secret_key'], 'HS256')
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
    unless valid_name(user_name) || valid_name(password)
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
          token: JWT.encode(id, config['secret_key'], 'HS256')
        }
      }
    end
  end

  put '/api/users/password' do
    not_found { status 404 } if params['user_name'].nil? ||
                                params['password'].nil? ||
                                params['new_password'].nil?
    user_name = params['user_name']
    password = params['password']
    new_password = params['new_password']
    unless valid_name(user_name) || valid_name(password) || valid_name(new_password)
      return { status: false, message: 'PARAMS_INVALID' }
    end

    if User.exists?(user_name)
      user = User.by_user_name(user_name)
      if user.validate_password(password)
        user.change_password(new_password)
        config = YAML.safe_load(File.open('config/config.yml'))
        return {
          status: true,
          data: {
            token: JWT.encode(user.id, config['secret_key'], 'HS256')
          }
        }
      else
        return { status: false, message: 'INVALID_CREDENTIALS' }
      end
    else
      return { status: false, message: 'USER_NOT_EXISTS' }
    end
  end

  after do
    response.body = JSON.dump(response.body)
  end
end
