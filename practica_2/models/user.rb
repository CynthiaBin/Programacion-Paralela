require_relative './abstract_base'
require_relative './driver'

# Model user
class User < AbstractBase
  attr_reader :id
  attr_reader :name
  attr_reader :user_name
  attr_reader :email

  def initialize(name = nil, user_name = nil, email = nil, id = nil)
    @id = id
    @name = name
    @user_name = user_name
    @email = email
    super(:users)
  end

  def register
    @id = @table.insert(name: @name, user_name: @user_name, email: @email)
  end

  def self.by_id(id)
    table = Driver.table_instance(:users)
    data = table.where(id: id).first
    User.new(data[:name], data[:user_name], data[:email], data[:id])
  end

  def self.by_name(name)
    table = Driver.table_instance(:users)
    data = table.where(name: name).first
    User.new(data[:name], data[:user_name], data[:email], data[:id])
  end
end
