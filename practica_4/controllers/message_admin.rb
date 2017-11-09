require_relative '../models/user'
require_relative '../models/queue'
require_relative '../models/subscription'
require_relative '../models/message'
require_relative '../models/message_status'

# Messages controller
class MessageAdmin
  def new_message(text, queue_name)
    queue = MQueue.new
    queue_data = queue.by_name(queue_name)
    message = Message.new(text, queue_data[:id])
    message.save
  end

  def messages_by_queue(queue_name)
    messages = Message.new
    queue = MQueue.new
    queue_data = queue.by_name(queue_name)
    messages.list_by_queue(queue_data[:id])
  end

  def link_messages(user_name, messages, queue_name)
    user = User.new
    user_data = user.by_name(user_name)
    puts user_data
    subscription = Subscription.new
    subscription_data = subscription.by_uid(user_data[:id])
    puts subscription_data
    queue = MQueue.new
    queue_data = queue.by_name(queue_name)
    puts queue_data

    messages.each { |row|
      status = Status.new(row[:id],
                          queue_data[:id],
                          subscription_data[:id],
                          nil, false, false)
      status.save_status
    }
  end

  def link_new_message(queue_name, msg_id)
    queue = MQueue.new
    queue_data = queue.by_name(queue_name)
    subscription = Subscription.new
    subscribers = subscription.list_users_in_queue(queue_data[:id])
    subscribers.each { |row|
      status = Status.new(msg_id,
                          queue_data[:id],
                          row[:id], nil, false, false)
      status.save_status
    }
    message = Message.new
    message.by_id(msg_id)
  end
end
