require_relative 'abstract_base'

# Subscription model
class Subscription < AbstractBase
  def initialize(u_id, q_id)
    @u_id = u_id
    @q_id = q_id
    super(:subscriptions)
  end

  def register(u_id, q_id)
    data_set = DB[@table_name]
    @id = data_set.insert(queue_id: q_id, user_id: u_id)
  end
end
