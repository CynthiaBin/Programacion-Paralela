require 'httparty'
require_relative './models/server'
require_relative './models/file'
# Client
class Daemon
  include HTTParty
  base_uri 'localhost:9292'

  def delete_(server_name, current_file)
    url = '/files/' + server_name + '/' + current_file
    self.class.delete(url)
  end

  def copy_(server_name, current_file, target)
    url = '/files/' + current_file
    body = { command: 'cp', target: '../' + server_name + target }
    self.class.patch(url, body: body)
  end

  def run
    for_ever = true
    Thread.new do
      while for_ever
        servers = []
        ServerM.servers.each { |server| servers.push(server.uri) }
        p_deletes = FileM.by_status('PENDING_DELETE')
        p_deletes.each do |file|
          start_deletes(file.path, servers)
          file.update_status('DELETED')
        end

        p_copies = FileM.by_status('PENDING_COPY')
        p_copies.each do |file|
          start_copies_(file.path, servers)
          file.update_status('ACTIVE')
        end

        sleep 100
      end
    end
  end

  def start_copies_(current_file, servers)
    t_file = current_file
    from_server = ''
    servers.each do |server_name|
      if current_file.index(server_name) == 1
        t_file = current_file.gsub '/' + server_name, ''
        from_server = server_name
      end
    end
    servers.each do |server_name|
      copy_(server_name, current_file, t_file) unless from_server == server_name
    end
  end

  def start_deletes(current_file, servers)
    servers.each do |server_name|
      if current_file.index(server_name) == 1
        current_file = current_file.gsub '/' + server_name, ''
      end
    end
    servers.each { |server_name| delete_(server_name, current_file) }
  end
end
