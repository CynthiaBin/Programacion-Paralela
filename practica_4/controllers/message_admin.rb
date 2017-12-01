require_relative '../models/user'
require_relative '../models/queue'
require_relative '../models/subscription'
require_relative '../models/message'
require_relative '../models/message_status'

# Messages controller
class MessageAdmin
  def self.new_message(text, queue_name)
    ex = Ant::Exceptions::AntFail.new('Queue not exists', 'QUEUE_NOT_EXISTS')
    queue = MQueue.by_name(queue_name)
    raise(ex) if queue.nil?

    message = Message.new(text, queue.id)
    message.register
  end

  def self.messages_by_queue(queue_name)
    Message.list_by_queue(MQueue.by_name(queue_name).id)
  end

  def self.link_messages(user_name, messages, queue_name)
    ex = Ant::Exceptions::AntFail.new('Not registered', 'NOT_REGISTERED')
    user = User.by_name(user_name)
    queue = MQueue.by_name(queue_name)
    raise(ex) if user.nil? || queue.nil?
    subscription = Subscription.validate(user.id, queue.id)
    raise(ex) if subscription.nil?
    messages.each do |d|
      status = Status.new(d[:id], queue.id, subscription.id, nil, false, false)
      status.register
    end
  end

  def self.purge(user_name, queue_name)
    ex = Ant::Exceptions::AntFail.new('Not registered', 'NOT_REGISTERED')
    user = User.by_name(user_name)
    queue = MQueue.by_name(queue_name)
    raise(ex) if user.nil? || queue.nil?
    subscription = Subscription.validate(user.id, queue.id)
    raise(ex) if subscription.nil?

    Status.purge(queue.id, subscription.id)
  end

  def self.link_new_message(queue_name, msg_id)
    ex = Ant::Exceptions::AntFail.new('Queue not exists', 'QUEUE_NOT_EXISTS')
    queue = MQueue.by_name(queue_name)
    raise(ex) if queue.nil?

    subscribers = Subscription.list_users_in_queue(queue.id)
    subscribers.each do |row|
      status = Status.new(msg_id, row[:queue_id], row[:id], nil, false, false)
      status.register
    end
    Message.by_id(msg_id)
  end

  def self.next_message(subscriber, queue_name)
    ex_q = Ant::Exceptions::AntFail.new('Not exists', 'NOT_EXISTS')
    ex_s = Ant::Exceptions::AntFail.new('Not registered', 'NOT_REGISTERED')
    user = User.by_name(subscriber)
    queue = MQueue.by_name(queue_name)
    raise(ex_q) if user.nil? || queue.nil?
    subscription = Subscription.validate(user.id, queue.id)
    raise(ex_s) if subscription.nil?

    message_id = Status.next_message(queue.id, subscription.id)
    unless message_id.nil?
      Status.read_message(message_id, queue.id, subscription.id)
    end
  end
end
