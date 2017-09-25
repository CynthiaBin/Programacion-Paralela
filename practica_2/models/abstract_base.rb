require 'sequel'
require 'yaml'

# Base abstract class
class AbstractBase
  db_link = YAML.safe_load(File.open('.\config\config.yml'))
  db_link_hash = Hash[db_link.map { |k, v| [k.to_sym, v] }]
  DB = Sequel.postgres(database: db_link_hash[:database],
                       user: db_link_hash[:user],
                       host: db_link_hash[:host])

  def initialize(table_name)
    @table_name = table_name
  end

  def by_id(id)
    data_set = DB[@table_name]
    data_set.where(id: id).first
  end

  def list_all
    DB[@table_name].all
  end

  def by_name(name)
    data_set = DB[@table_name]
    data_set.where(name: name).all
  end
end
