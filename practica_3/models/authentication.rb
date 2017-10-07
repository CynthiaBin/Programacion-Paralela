require 'securerandom'
require 'bcrypt'

# Model authentication
class Authentication < AbstractBase
  attr_reader :id

  def initialize(u_id, s_id, user_name, password)
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

  def validate_password(password)
    data = DB[@table_name]
    #password == data[:Password]?
  end
end
