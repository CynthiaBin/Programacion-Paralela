# Model site
class Site < AbstractBase
  attr_reader :id

  def initialize(name, url)
    @name = name
    @url = url
    super(:sites)
  end

  def register
    data_set = DB[@table_name]
    @id = data_set.insert(name: @name, url: @url)
  end

  def users_in_site
    tuple = by_name(@name)
    print tuple.to_s
    data_set = DB[:users].select(:name).inner_join(:user_has_accounts, userID: :id).where(siteID: tuple[:id]).all
  end

  def self.by_id(id)
    table = AbstractBase.table_instance(:site)
    data = table.where(id: id).first
    User.new(data[:name], data[:user_name], data[:email], data[:id])
  end

  def self.by_name(name)
    table = AbstractBase.table_instance(:site)
    data = table.where(name: name).first
    User.new(data[:name], data[:user_name], data[:email], data[:id])
  end
end
