
# Queue class
class MQueue < AbstractBase 
  attr_reader :name
  def initialize(name = nil)
    @name = name
    super(:queues)
  end

  def register
    dataset = DB[@table_name]
    @id = dataset.insert(name: @name)
  end
end
