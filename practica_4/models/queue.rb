require_relative './abstract_base'
require_relative './driver'

# Queue class
class MQueue < AbstractBase
  attr_reader :id
  attr_reader :name
  def initialize(name = nil, id = nil)
    @name = name
    @id = id
    super(:queues)
  end

  def register
    @id = @table.insert(name: @name)
  end

  def self.by_name(name)
    table = Driver.table_instance(:queues)
    data = table.where(name: name).first
    unless data.nil?
      MQueue.new(data[:name], data[:id])
    end
  end
end
