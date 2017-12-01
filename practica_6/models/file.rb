require_relative './abstract_base'
require_relative './driver'

# Model user
class FileM < AbstractBase
  attr_reader :id
  attr_reader :path
  attr_reader :hash
  attr_reader :status
  attr_reader :updated_at

  def initialize(path = nil, hash = nil, status = nil, updated_at = nil,
                 id = nil)
    @path = path
    @hash = hash
    @status = status
    @updated_at = updated_at
    @id = id
    super(:files)
  end

  def register
    @id = @table.insert(path: @path, hash: @hash,
                        status: @status, updated_at: @updated_at)
  end

  def self.by_id(id)
    table = Driver.table_instance(:files)
    data = table.where(id: id).first
    FileM.new(data[:path], data[:hash], data[:status],
              data[:updated_at], data[:id]) unless data.nil?
  end

  def self.by_hash(hash)
    table = Driver.table_instance(:files)
    data = table.where(hash: hash).first
    FileM.new(data[:path], data[:hash], data[:status],
              data[:updated_at], data[:id]) unless data.nil?
  end
end
