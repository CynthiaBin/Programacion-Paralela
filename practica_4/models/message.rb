require_relative './abstract_base'

# Message model
class Message < AbstractBase
  attr_reader :id
  def initialize(content_text = nil, queue_id = nil)
    @content = content_text
    @queue = queue_id
    super(:messages)
  end

  def save
    dataset = DB[@table_name]
    @id = dataset.insert(content: @content, queue_id: @queue)
  end

  def list_by_queue(queue_id)
    dataset = DB[@table_name]
    dataset.where(queue_id: queue_id).reverse(:created_at).all
  end
end
