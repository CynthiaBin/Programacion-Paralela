require 'grape'
require 'fileutils'
require 'ap'
require 'json'
require 'ant'
require 'awesome_print'
require_relative '../helpers/validation'

# Routes
module Routes
  # API
  class API < Grape::API
    get '*path' do
      error! :not_found, 404 if params[:path].nil?
      c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files')
      file = File.join(c_path, params[:path])
      if File.exist?(file) && File.directory?(file)
        files = []
        Dir.foreach(file) do |filename|
          basename = File.basename(filename)
          unless basename == '.' || basename == '..'
            files.push(basename)
          end
        end
        files
      elsif File.exist?(file) && !File.directory?(file)
        File.basename(file)
      else
        error! :not_found, 404
      end
    end

    post '*path' do
      process_request do
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
    end

    patch '*source' do
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

    delete '*path' do
      error! :not_found, 404 if params[:path].nil?

      c_path = File.join(File.dirname(File.dirname(__FILE__)), 'files')
      path = File.join(c_path, params[:path])

      error! :is_directory if File.directory?(path)

      File.unlink(path) if File.exist?(path)
      File.basename(path)
    end
  end
end
