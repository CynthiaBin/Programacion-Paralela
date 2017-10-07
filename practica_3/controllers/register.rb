
require 'jwt'
require 'ant'
require 'yaml'
require_relative '../models/authentication'
require_relative '../models/user'
require_relative '../models/site'

# Register interface
class Register
  def initialize(name, site_name, password)
    @name = name
    @site_name = site_name
    @password = password
  end

  def user_is_new
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
    if user_is_new
      user.register
    else
      user_data = user.by_name(@name)
      user_data[:id]
    end
  end
end
