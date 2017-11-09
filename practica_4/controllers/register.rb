
require 'jwt'
require 'ant'
require 'yaml'

require_relative '../models/user'
require_relative '../models/queue'
require_relative '../models/subscription'
require_relative '../models/authentication'
require_relative '../models/site'

# Register Controller
class Register
  attr_reader :name
  def initialize(name, site_name = nil, password = nil)
    @name = name
    @site_name = site_name
    @password = password
  end

  def user_is_new?
    user = User.new
    user = user.by_name(@name)
    user.nil?
  end

  def register_in_site
    u_id = userinfo_u_id
    site = Site.new(@site_name)
    site_data = site.by_name(@site_name)
    account = Authentication.new(u_id, site_data[:id], @name, @password)
    account.register

    config = YAML.safe_load(File.open('./config/config.yml'))
    {
      token: JWT.encode(u_id, config['secret_key'], 'HS256')
    }
  end

  def userinfo_u_id
    user = User.new(@name)
    if user_is_new?
      user.register
    else
      user_data = user.by_name(@name)
      user_data[:id]
    end
  end

  def register_in_queue(name, q_name)
    user = User.new
    queue = MQueue.new
    ex = Ant::Exceptions::AntFail.new(
      'Not registered', 'NOT_REGISTERED'
    )
    raise(ex) if user_is_new?
    user_data = user.by_name(name)
    queue_data = queue.by_name(q_name)
    subscription = Subscription.new(user_data[:id], queue_data[:id])
    subscription.register
  end
end