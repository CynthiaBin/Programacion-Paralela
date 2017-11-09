

# Subscription model
class Subscription < AbstractBase
  attr_reader :id
  def initialize(u_id = nil, q_id = nil)
    @u_id = u_id
    @q_id = q_id
    super(:subscriptions)
  end

  def register
    data_set = DB[@table_name]
    @id = data_set.insert(queue_id: @q_id, user_id: @u_id)
  end

  def by_uid(u_id)
    data_set = DB[@table_name]
    data_set.where(user_id: u_id).first
  end

  def list_users_in_queue(q_id)
    data_set = DB[@table_name]
    data_set.where(queue_id: q_id).all
  end
end
