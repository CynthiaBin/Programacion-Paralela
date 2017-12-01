require 'bcrypt'
require 'jwt'
require 'ant'
require_relative '../models/authentication'
require_relative '../models/user'
require_relative '../models/site'

# Authentication interface
class Auth
  def initialize(name, site_name, password)
    @name = name
    @site_name = site_name
    @password = password
  end

  def validate
    user_accounts = Authentication.new
    user = User.by_name(@name)
    site = Site.by_name(@site_name)
    ex = Ant::Exceptions::AntFail.new('Invalid credentials',
                                      'INVALID_CREDENTIALS')
    raise(ex) if site.nil? || user.nil?
    account = user_accounts.account(user.id, site.id)
    raise(ex) unless validate_password(account.salt, account.password)
    config = YAML.safe_load(File.open('./config/config.yml'))
    {
      token: JWT.encode(user.id, config['secret_key'], 'HS256')
    }
  end

  def validate_password(salt, password)
    password = BCrypt::Password.new(password)
    password == salt + @password
  end
end
