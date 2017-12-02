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

  def self.by_id(id)
    table = Driver.table_instance(:queues)
    data = table.where(id: id).first
    MQueue.new(data[:name], data[:id]) unless data.nil?
  end

  def self.list_by_user_id(user_id)
    table = Driver.table_instance(:subscriptions)
    data = table.join_table(:inner, :queues, id: :queue_id)
                .where(user_id: user_id)
    queues = []
    data.all.each { |q| queues.push(name: q[:name], id: q[:queue_id]) }
    queues
  end

  def self.by_name(name)
    table = Driver.table_instance(:queues)
    data = table.where(name: name).first
    MQueue.new(data[:name], data[:id]) unless data.nil?
  end

  def self.exists?(name)
    table = Driver.table_instance(:queues)
    d = table.where(name: name).first
    !d.nil?
  end
end
