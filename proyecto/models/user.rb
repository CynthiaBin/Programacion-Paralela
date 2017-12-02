require_relative './abstract_base'
require_relative './driver'
require 'securerandom'
require 'bcrypt'

# Model authentication
class User < AbstractBase
  attr_reader :id
  attr_reader :user_name
  attr_reader :password
  attr_reader :salt

  def initialize(user_name = nil, password = nil, salt = nil, id = nil)
    @user_name = user_name
    @password = password
    @salt = salt
    @id = id
    super(:users)
  end

  def register
    @salt = SecureRandom.hex
    @id = @table.insert(user_name: @user_name,
                        password:  BCrypt::Password.create(@salt + @password),
                        salt: @salt)
  end

  def self.by_id(id)
    table = Driver.table_instance(:users)
    d = table.where(id: id).first
    User.new(d[:user_name], d[:password], d[:salt], d[:id]) unless d.nil?
  end

  def self.by_user_name(user_name)
    table = Driver.table_instance(:users)
    d = table.where(user_name: user_name).first
    User.new(d[:user_name], d[:password], d[:salt], d[:id]) unless d.nil?
  end

  def self.exists?(user_name)
    table = Driver.table_instance(:users)
    d = table.where(user_name: user_name).first
    !d.nil?
  end

  def change_password(new_password)
    @table.where(id: @id).update(
      password: BCrypt::Password.create(@salt + new_password)
    )
  end

  def validate_password(password)
    ap BCrypt::Password.new(@password)
    BCrypt::Password.new(@password) == @salt + password
  end
end
