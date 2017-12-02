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

  def self.chat1_1(u_id_one, u_id_two)
    table = Driver.table_instance(:subscriptions)
    data = table.where(user_id: [u_id_one,u_id_two]).group_and_count(:queue_id)
                .having{ Sequel.lit('count(*) = 2') }

    data.first[:queue_id]
  end

  def self.validate(u_id, q_id)
    table = Driver.table_instance(:subscriptions)
    d = table.where(user_id: u_id, queue_id: q_id).first
    Subscription.new(d[:user_id], d[:queue_id], d[:id]) unless d.nil?
  end

  def self.exists_user?(u_id, q_id)
    table = Driver.table_instance(:subscriptions)
    d = table.where(user_id: u_id, queue_id: q_id).first
    !d.nil?
  end

  def self.delete(u_id, q_id)
    table = Driver.table_instance(:subscriptions)
    table.where(user_id: u_id, queue_id: q_id).delete
  end

  def self.list_users_in_queue(q_id)
    table = Driver.table_instance(:subscriptions)
    table.where(queue_id: q_id).all
  end
end
