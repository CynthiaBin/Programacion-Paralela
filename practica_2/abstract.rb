require 'helper'
require 'sequel'

# Base
class AbstractBase

  DB = Sequel.connect(Helper.constructURL)

  def intialized(*data)
    @alias = data[:alias]
    @name = data[:name]
    @link = data[:link]
  end

  def register
    data_set = DB[:table]
    data_set.insert(alias: @alias, name: @name, link: @link)
  end

  def by_id(id)
    data_set = DB[:table]
    tuple = data_set.select(:alias, :name, :link).where(id: id)
    new(tuple)
  end

  def list_all
    data_set_all = DB.from(:table)
    data_set_all
  end

  def by_name(name)
    data_set = DB[:table]
    data_set.select(:alias, :name, :link).where(name: name)
  end
end
