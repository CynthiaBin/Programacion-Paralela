require 'sequel/extensions/pagination'
require_relative './abstract_base'
require_relative './driver'

# Message model
class Message < AbstractBase
  attr_reader :content
  attr_reader :queue_id
  attr_reader :user_id
  attr_reader :id
  attr_reader :created_at

  def initialize(content = nil, queue_id = nil, user_id = nil, id = nil, created_at = nil)
    @content = content
    @queue_id = queue_id
    @user_id = user_id
    @id = id
    @created_at = created_at
    super(:messages)
  end

  def self.by_id(id)
    table = Driver.table_instance(:messages)
    data = table.where(id: id).first
    unless data.nil?
      Message.new(data[:content], data[:queue_id], data[:user_id], data[:id], data[:created_at])
    end
  end

  def register
    @id = @table.insert(content: @content, queue_id: @queue_id, user_id: @user_id)
  end

  def self.list_by_queue(queue_id, page = 1, limit = 200)
    table = Driver.table_instance(:messages)
    data = table.where(queue_id: queue_id)
    data.extension(:pagination).paginate(page, limit).all
  end

  def self.list_by_user(user_id)
    table = Driver.table_instance(:messages)
    data = table.where(user_id: user_id).reverse(:created_at).all
    !data.nil? ? data : []
  end
end
