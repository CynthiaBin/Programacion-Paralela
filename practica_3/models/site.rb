# Model site
class Site < AbstractBase
  attr_reader :id

  def initialize(name = nil, url = nil)
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
    DB[:users].select(:name)
              .inner_join(:user_has_accounts, userID: :id)
              .where(siteID: tuple[:id]).all
  end

end
