require_relative './abstract_base'
require_relative './driver'

# Model server
class Server < AbstractBase
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
    Server.new(data[:uri], data[:id]) unless data.nil?
  end

  def self.by_uri(url)
    table = Driver.table_instance(:servers)
    data = table.where(uri: url).first
    Server.new(data[:uri], data[:id]) unless data.nil?
  end

  def self.servers
    table = Driver.table_instance(:servers)
    data = table.where(uri: url).all
    servers = []
    data.foreach do |row|
      servers.push(Server.new(row[:uri], row[:id]))
    end
    !servers.empty? ? servers : []
  end
end
