
require 'sequel'
require 'yaml'

# Base
class AbstractBase

  db_link = YAML.safe_load(File.open('.\config\config.yml'))
  
  DB = Sequel.postgres(db_link['database'], user: db_link['user'], host: db_link['host'])

  
  def initialize(data)
    @alias = data[:alias]
    @name = data[:name]
    @link = data[:link]

    register
  end

  def register
    data_set = DB[:tabla]
    puts "#{@alias}#{@name}#{@link}"
    data_set.insert(alias: @alias, name: @name, link: @link)
  end

  def by_id(id)
    data_set = DB[:tabla]
    tuple = data_set.select(:alias, :name, :link).where(id: id)
    new(tuple)
  end

  def list_all
    DB[:tabla].all
  end

  def by_name(name)
    data_set = DB[:tabla]
    data_set.select(:alias, :name, :link).where(name: name).all
  end
end