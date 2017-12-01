require_relative './abstract_base'
require_relative './driver'

# Subscription model
class Subscription < AbstractBase
  attr_reader :u_id
  attr_reader :q_id
  attr_reader :id
  def initialize(u_id = nil, q_id = nil, id = nil)
    @u_id = u_id
    @q_id = q_id
    @id = id
    super(:subscriptions)
  end

  def register
    @id = @table.insert(queue_id: @q_id, user_id: @u_id)
  end

  def self.validate(u_id, q_id)
    table = Driver.table_instance(:subscriptions)
    data = table.where(user_id: u_id, queue_id: q_id).first
    unless data.nil?
      Subscription.new(data[:user_id], data[:queue_id], data[:id])
    end
  end

  def self.list_users_in_queue(q_id)
    table = Driver.table_instance(:subscriptions)
    table.where(queue_id: q_id).all
  end
end
