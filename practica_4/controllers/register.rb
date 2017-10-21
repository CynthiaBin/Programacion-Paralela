require_relative '..\models\user'
require_relative '..\models\queue'
require_relative '..\models\subscription'

# Register Controller
class Register
    def initialize(name, q_name)
      @name = name
      @q_name = q_name
    end

    def register_in_queue
      user = User.new
      queue = Queue.new
      subscription = Subscription.new
      subscription.register(user.by_name(@name), queue.by_name(@q_name))
    end
end