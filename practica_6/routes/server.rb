require 'json'
require 'sinatra/base'

# Server
class Server < Sinatra::Application
  get '/api/*' do |path|
    not_found { 'This is nowhere to be found.' } if path.nil?
    c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files')
    file = File.join(c_path, path)
    if File.exist?(file) && File.directory?(file)
      files = []
      Dir.foreach(file) do |filename|
        basename = File.join(file, filename).gsub c_path, ''
        basename = Digest::SHA1.hexdigest(basename) if params['hash'] == 'true'
        files.push(basename) unless ['.', '..'].include?(filename)
      end
      files.to_json
    elsif File.exist?(file) && !File.directory?(file)
      basename = file.gsub c_path, ''
      basename = Digest::SHA1.hexdigest(basename) if params['hash'] == 'true'
      basename.to_json
    else
      not_found { 'This is nowhere to be found.' }
    end
  end

  post '/api/:path' do
    error! :not_found, 404 if params[:path].nil?
    contents = params[:contents]
    c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files')
    file = File.join(c_path, params[:path])

    FileUtils.mkdir_p(File.dirname(file))
    out_file = File.new(file, File.exist?(file) ? 'a' : 'w')
    out_file.puts(contents) unless contents.nil?
    out_file.close
    File.basename(file)
  end

  patch '/api/:source' do
    error! :not_found, 404 if params[:source].nil? ||
                              params[:command].nil? ||
                              params[:target].nil?

    c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files')
    source = File.join(c_path, params[:source])
    target = File.join(c_path, params[:target])
    error! :not_found, 404 unless File.exist?(source)

    if params[:command] == 'cp'
      FileUtils.mkdir_p(File.dirname(target))
      FileUtils.cp(source, target)
      File.basename(target)
    elsif params[:command] == 'mv'
      FileUtils.mkdir_p(File.dirname(target))
      FileUtils.mv(source, target)
      File.basename(target)
    else
      error! :not_found, 404
    end
  end

  delete '/api/:path' do
    error! :not_found, 404 if params[:path].nil?

    c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files')
    path = File.join(c_path, params[:path])

    error! :is_directory if File.directory?(path)

    File.unlink(path) if File.exist?(path)
    File.basename(path)
  end
end
