def sanitize_filename(filename)
  filename.gsub(/[^0-9A-Z]/i, '_')
end
