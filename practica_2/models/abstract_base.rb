require 'sequel'
require 'yaml'
require_relative './driver'

# Base abstract class
class AbstractBase < Driver
  attr_reader :table
  def initialize(table_name)
    super()
    @table = @db[table_name]
  end

  def list_all
    @table.all
  end

  def self.by_id(id)
    @table.where(id: id).first
  end

  def self.by_name(name)
    @table.where(name: name).first
  end
end
