require 'json'
require 'sinatra/base'

# Server
class Server < Sinatra::Application
  before do
    content_type :json
  end

  get '/files/*/*' do |server_n, path|
    not_found { status 404 } if path.nil? || server_n.nil?
    c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files', server_n)
    file = File.join(c_path, path)
    if File.exist?(file) && File.directory?(file)
      files = []
      Dir.foreach(file) do |filename|
        basename = File.join(file, filename).gsub c_path, ''
        basename = Digest::SHA1.hexdigest(basename) if params['hash'] == 'true'
        files.push(basename) unless ['.', '..'].include?(filename)
      end
      files
    elsif File.exist?(file) && !File.directory?(file)
      basename = file.gsub c_path, ''
      basename = Digest::SHA1.hexdigest(basename) if params['hash'] == 'true'
      basename
    else
      not_found { status 404 }
    end
  end

  post '/files/*/*' do |server_n, path|
    not_found { status 404 } if path.nil? || server_n.nil?
    contents = params['contents']
    c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files', server_n)
    file = File.join(c_path, path)

    FileUtils.mkdir_p(File.dirname(file))
    out_file = File.new(file, File.exist?(file) ? 'a' : 'w')
    out_file.puts(contents) unless contents.nil?
    out_file.close
    file.gsub c_path, ''
  end

  patch '/files/*/*' do |server_n, source|
    not_found { status 404 } if source.nil? || server_n.nil? ||
                                params['command'].nil? ||params['target'].nil?

    c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files', server_n)
    source = File.join(c_path, source)
    target = File.join(c_path, params['target'])
    not_found { status 404 } unless File.exist?(source)

    if params['command'] == 'cp'
      FileUtils.mkdir_p(File.dirname(target))
      FileUtils.cp(source, target)
      target.gsub c_path, ''
    elsif params['command'] == 'mv'
      FileUtils.mkdir_p(File.dirname(target))
      FileUtils.mv(source, target)
      target.gsub c_path, ''
    else
      not_found { status 404 }
    end
  end

  delete '/files/*/*' do |server_n, path|
    not_found { status 404 } if path.nil? || server_n.nil?

    c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files', server_n)
    path = File.join(c_path, path)

    not_found { status 404 } if File.directory?(path) || !File.exist?(path)

    File.unlink(path)
    path.gsub c_path, ''
  end

  after do
    response.body = JSON.dump(response.body)
  end
end
