require 'ant'

def valid_name(string)
  ex = Ant::Exceptions::AntFail.new('Invalid name',
                                    'INVALID_NAME'
                                    )
  raise(ex) unless string.match? (/^(([a-z]|[0-9]|_)+)$/i)
end
