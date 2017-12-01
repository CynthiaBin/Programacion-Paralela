require 'sequel'
require 'yaml'

# Driver Postgres
class Driver
  attr_reader :db
  def initialize
    db_link = YAML.safe_load(File.open('./config/config.yml'))
    db_link_hash = Hash[db_link.map { |k, v| [k.to_sym, v] }]
    @db = Sequel.connect(adapter: db_link_hash[:adapter],
                         database: db_link_hash[:database],
                         user: db_link_hash[:user],
                         password: db_link_hash[:password],
                         host: db_link_hash[:host],
                         port: db_link_hash[:port])
  end

  def self.table_instance(table_name)
    driver = Driver.new
    driver.db[table_name]
  end
end
