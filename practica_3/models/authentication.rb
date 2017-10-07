require 'securerandom'
require 'bcrypt'

# Model authentication
class Authentication < AbstractBase
  attr_reader :id

  def initialize(u_id = nil, s_id = nil, user_name = nil, password = nil)
    @u_id = u_id
    @s_id = s_id
    @user_name = user_name
    @password = password
    super(:user_has_accounts)
  end

  def register
    data_set = DB[@table_name]
    salt = SecureRandom.hex
    @id = data_set.insert(userName: @user_name,
                          password:  BCrypt::Password.create(salt + @password),
                          salt: salt,
                          userID: @u_id,
                          siteID: @s_id)
  end

  def account(user_id, site_id)
    DB[@table_name].where{Sequel.&({userID: user_id},{siteID: site_id})}.first
  end
end