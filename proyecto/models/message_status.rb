require_relative './abstract_base'
require_relative './driver'
require 'date'

# Message status model
class Status < AbstractBase
  attr_reader :message_id
  attr_reader :queue_id
  attr_reader :subscription_id
  attr_reader :read_at
  attr_reader :shadowed
  attr_reader :processed
  attr_reader :id


  def initialize(message_id = nil, queue_id = nil, subscription_id = nil,
                read_at = nil, shadowed = false, processed = false, id = nil)
    @message_id = message_id
    @queue_id = queue_id
    @subscription_id = subscription_id
    @read_at = read_at
    @shadowed = shadowed
    @processed = processed
    @id = id
    super(:messages_status)
  end

  def register
    @id = @table.insert(message_id: @message_id,
                        queue_id: @queue_id,
                        subscription_id: @subscription_id,
                        read_at: @read_at,
                        shadowed: @shadowed,
                        processed: @processed)
  end

  def self.modify_status(shadowed, processed, id)
    table = Driver.table_instance(:messages_status)
    @shadowed = shadowed
    @processed = processed

    table.where(id: id).update(shadowed: @shadowed, processed: @processed)
  end

  def self.purge(queue_id, subscription_id)
    table = Driver.table_instance(:messages_status)
    table.where(
      Sequel.&({ queue_id: queue_id }, { subscription_id: subscription_id })
    ).update(
      read_at: DateTime.now.to_s, shadowed: true, processed: true
    )
  end

  def self.next_message(queue_id, subscription_id)
    table = Driver.table_instance(:messages_status)
    subscription = table.where(
      Sequel.&({ queue_id: queue_id }, { subscription_id: subscription_id },
               { shadowed: false }, { processed: false })
    ).all
    unless subscription.empty? || subscription.nil?
      subscription = subscription[0]
      unless subscription.nil?
        subscription[:message_id]
      end
    end
  end

  def self.read_message(message_id, queue_id, subscription_id)
    messages_status = Driver.table_instance(:messages_status)
    updated = messages_status.where(
      Sequel.&({ queue_id: queue_id }, { message_id: message_id },
               { subscription_id: subscription_id })
    ).update(
      read_at: DateTime.now.to_s, shadowed: true, processed: true
    )

    Message.by_id(message_id)
  end
end
