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
end
