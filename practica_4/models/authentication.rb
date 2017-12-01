require_relative './abstract_base'
require_relative './driver'
require 'securerandom'
require 'bcrypt'

# Model authentication
class Authentication < AbstractBase
  attr_reader :id
  attr_reader :u_id
  attr_reader :s_id
  attr_reader :user_name
  attr_reader :password
  attr_reader :salt

  def initialize(u_id = nil, s_id = nil, user_name = nil, password = nil, 
                 salt = nil)
    @u_id = u_id
    @s_id = s_id
    @user_name = user_name
    @password = password
    @salt = salt
    super(:user_has_accounts)
  end

  def register
    salt = SecureRandom.hex
    @id = @table.insert(user_name: @user_name,
                        password:  BCrypt::Password.create(salt + @password),
                        salt: salt, user_id: @u_id, site_id: @s_id)
  end

  def account(user_id, site_id)
    data = @table.where { Sequel.&({ user_id: user_id }, { site_id: site_id }) }
    data = data.first
    unless data.nil?
      Authentication.new(data[:user_id], data[:site_id],
                         data[:user_name], data[:password], data[:salt])
    end
  end
end
