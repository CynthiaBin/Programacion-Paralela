# Model user
class User < AbstractBase
  attr_reader :id

  def initialize(name, user_name, email)
    @name = name
    @user_name = user_name
    @email = email
    super(:users)
  end

  def register
    data_set = DB[@table_name]
    @id = data_set.insert(name: @name, userName: @user_name, email: @email)
  end
end
