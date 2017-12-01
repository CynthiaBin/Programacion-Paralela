
require 'jwt'
require 'ant'
require 'yaml'

require_relative '../models/abstract_base'
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
    user = User.by_name(@name)
    user.nil?
  end

  def register_in_site
    u_id = userinfo_u_id
    account = Authentication.new(u_id, Site.by_name(@site_name).id, @name,
                                 @password)
    account.register

    config = YAML.safe_load(File.open('./config/config.yml'))
    {
      token: JWT.encode(u_id, config['secret_key'], 'HS256')
    }
  end

  def userinfo_u_id
    if user_is_new?
      user = User.new(@name, @name, @name)
      user.register
    else
      User.by_name(@name).id
    end
  end

  def register_in_queue(q_name)
    ex = Ant::Exceptions::AntFail.new('Not registered', 'NOT_REGISTERED')
    user = User.by_name(@name)
    queue = MQueue.by_name(q_name)

    raise(ex) if user.nil? || queue.nil?

    subscription = Subscription.new(user.id, queue.id)
    subscription.register
  end
end
