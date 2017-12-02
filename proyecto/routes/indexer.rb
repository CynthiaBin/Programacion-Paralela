require 'json'
require 'sinatra/base'
require_relative '../models/server'
require_relative '../models/file'

# Server
class Indexer < Sinatra::Application
  before do
    content_type :json
  end

  get '/indexer/*' do |path|
    not_found { status 404 } if path.nil?
    ServerM.servers.each do |server|
      uri = server.uri
      file_active = FileM.by_path(File.join('/', uri, path))
      not_found { status 404 } if file_active.nil?
      c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files')
      file = File.join(c_path, file_active.path)
      if File.exist?(file) && !File.directory?(file)
        sha1 = Digest::SHA1.hexdigest(File.read(file))
        if sha1 == file_active.hash
          return file.gsub c_path, ''
        else
          File.unlink(file)
        end
      else
        next
      end
    end
    not_found { status 404 }
  end

  post '/indexer/*' do |path|
    not_found { status 404 } if path.nil?
    contents = params['contents']
    server = ServerM.first
    not_found { status 404 } if server.nil?
    server_n = server.uri
    c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files', server_n)
    file = File.join(c_path, path)

    not_found { status 404 } if File.exist?(file)
    FileUtils.mkdir_p(File.dirname(file))
    out_file = File.new(file, 'w+')
    out_file.puts(contents) unless contents.nil?
    out_file.close
    sha1 = Digest::SHA1.hexdigest(File.read(out_file))
    path_to_insert = File.join('/',server_n, path)
    filem_ = FileM.new(path_to_insert, sha1, 'PENDING_COPY')
    filem_.register
    path_to_insert
  end

  patch '/indexer/*' do |source|
    not_found { status 404 } if source.nil? || params['command'].nil? ||
                                params['target'].nil?
    ServerM.servers.each do |server|
      uri = server.uri
      file_active = FileM.by_path(File.join('/', uri, source))
      not_found { status 404 } if file_active.nil?
      c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files')
      file = File.join(c_path, file_active.path)
      if File.exist?(file) && !File.directory?(file)
        sha1 = Digest::SHA1.hexdigest(File.read(file))
        if sha1 == file_active.hash
          target = params['target']
          target = File.join(c_path, uri, target)
          to_insert = target.gsub c_path, ''
          FileUtils.mkdir_p(File.dirname(target))
          if params['command'] == 'cp'
            FileUtils.cp(file, target)
          else
            FileUtils.mv(file, target)
            file_active.update_status('PENDING_DELETE')
          end
          filem_ = FileM.new(to_insert, sha1, 'PENDING_COPY')
          filem_.register
          return to_insert
        else
          File.unlink(file)
        end
      else
        next
      end
    end
  end

  delete '/indexer/*' do |path|
    ServerM.servers.each do |server|
      uri = server.uri
      file_active = FileM.by_path(File.join('/', uri, path))
      not_found { status 404 } if file_active.nil?
      c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files')
      file = File.join(c_path, file_active.path)
      if File.exist?(file) && !File.directory?(file)
        sha1 = Digest::SHA1.hexdigest(File.read(file))
        if sha1 == file_active.hash
          file_active.update_status('PENDING_DELETE')
          return file.gsub c_path, ''
        else
          File.unlink(file)
        end
      else
        next
      end
    end
    not_found { status 404 }
  end

  after do
    response.body = JSON.dump(response.body)
  end
end
