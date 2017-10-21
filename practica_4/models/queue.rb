require_relative 'abstract_base.rb'
# Queue class
class Queue < AbstractBase
  def initialize(name)
    @name = name
    super(:queues)
  end

  def register
    dataset = DB[@table_name]
    @id = dataset.insert(name: @name)
  end

end
