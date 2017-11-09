

# Message status model
class Status < AbstractBase
  def  initialize(message_id, queue_id, subscription_id, read_at, shadowed, processed)
    @message_id = message_id
    @queue_id = queue_id
    @subscription_id = subscription_id
    @read_at = read_at
    @shadowed = shadowed
    @processed = processed
    super(:messages_status)
  end

  def save_status
    dataset = DB[@table_name]
    @id = dataset.insert(message_id: @message_id,
                         queue_id: @queue_id,
                         subscription_id: @subscription_id,
                         read_at: @read_at,
                         shadowed: @shadowed,
                         processed: @processed)
  end

  def modify_status(shadowed, processed)
    @shadowed = shadowed
    @processed = processed

    dataset = DB[table_name]
    dataset.where(id: @id).update(shadowed: @shadowed, processed: @processed)
  end
end

