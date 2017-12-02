require_relative './abstract_base'
require_relative './driver'

# Model server
class ServerM < AbstractBase
  attr_reader :id
  attr_reader :uri

  def initialize(url = nil, id = nil)
    @id = id
    @uri = url
    super(:servers)
  end

  def register
    @id = @table.insert(uri: @uri)
  end

  def self.by_id(id)
    table = Driver.table_instance(:servers)
    data = table.where(id: id).first
    ServerM.new(data[:uri], data[:id]) unless data.nil?
  end

  def self.by_uri(url)
    table = Driver.table_instance(:servers)
    data = table.where(uri: url).first
    ServerM.new(data[:uri], data[:id]) unless data.nil?
  end

  def self.first
    table = Driver.table_instance(:servers)
    data = table.first
    ServerM.new(data[:uri], data[:id]) unless data.nil?
  end

  def self.servers
    table = Driver.table_instance(:servers)
    data = table.all
    servers = []
    data.each do |row|
      servers.push(ServerM.new(row[:uri], row[:id]))
    end
    !servers.empty? ? servers : []
  end
end
