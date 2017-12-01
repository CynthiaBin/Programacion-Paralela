require_relative './abstract_base'
require_relative './driver'

# Model site
class Site < AbstractBase
  attr_reader :id
  attr_reader :name
  attr_reader :url

  def initialize(name = nil, url = nil, id = nil)
    @name = name
    @url = url
    @id = id
    super(:sites)
  end

  def register
    @id = @table.insert(name: @name, url: @url)
  end

  def users_in_site
    tuple = Site.by_name(@name)
    if !tuple.nil?
      @db[:users].select(:name)
                 .inner_join(:user_has_accounts, user_id: :id)
                 .where(site_id: tuple.id).all
    else
      []
    end
  end

  def self.by_id(id)
    table = Driver.table_instance(:sites)
    data = table.where(id: id).first
    unless data.nil? 
      Site.new(data[:name], data[:url], data[:id])
    end
  end

  def self.by_name(name)
    table = Driver.table_instance(:sites)
    data = table.where(name: name).first
    unless data.nil? 
      Site.new(data[:name], data[:url], data[:id])
    end
  end
end
