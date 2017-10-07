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
    user = User.new
    puts user
    site = Site.new
    puts site
    user_accounts = Authentication.new
    puts user_accounts

    user_info = user.by_name(@name)
    puts user_info
    site = site.by_name(@site_name)
    puts site
    puts user_info[:id]
    puts  site[:id]
    account = user_accounts.account(user_info[:id], site[:id])

    ex = Ant::Exceptions::AntFail.new(
      'Invalid credentials',
      'INVALID_CREDENTIALS'
    )
    raise(ex) unless validate_password(account[:salt], account[:password])

    config = YAML.safe_load(File.open('./config/config.yml'))
   
    {
      token: JWT.encode(user_info[:id], config['secret_key'], 'HS256')
    }
  end

  def validate_password(salt, hash)
    password = BCrypt::Password.new(hash)
    password == salt + @password
  end
end
