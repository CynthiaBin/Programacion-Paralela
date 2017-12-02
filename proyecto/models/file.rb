require 'date'
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

  def update_status(status)
    @table.where(id: @id).update(status: status, updated_at: DateTime.now.to_s)
  end

  def self.by_id(id)
    table = Driver.table_instance(:files)
    d = table.where(id: id).first
    FileM.new(d[:path], d[:hash], d[:status], d[:updated_at], d[:id]) unless d.nil?
  end

  def self.by_hash(hash)
    table = Driver.table_instance(:files)
    d = table.where(hash: hash).first
    FileM.new(d[:path], d[:hash], d[:status], d[:updated_at], d[:id]) unless d.nil?
  end

  def self.by_path(path)
    table = Driver.table_instance(:files)
    d = table.where( path: path, status: ['ACTIVE', 'PENDING_COPY']).first
    FileM.new(d[:path], d[:hash], d[:status], d[:updated_at], d[:id]) unless d.nil?
  end

  # DELETED ACTIVE PENDING_DELETE PENDING_COPY
  def self.by_status(status = 'ACTIVE')
    table = Driver.table_instance(:files)
    data = table.where(status: status).all
    servers = []
    data.each do |d|
      servers.push(FileM.new(d[:path], d[:hash], d[:status], d[:updated_at], d[:id]))
    end
    servers
  end
end
