require 'jwt'
require 'yaml'

def valid_name(string)
  string.match? (/^(([a-z]|[0-9]|_)+)$/i)
end

def decode_id(token)
  config = YAML.safe_load(File.open('config/config.yml'))
  begin
    decoded = JWT.decode(token, config['secret_key'], false)
    return !decoded.empty? ? decoded[0] : -1
  rescue
    return -1
  end
end
