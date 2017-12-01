require 'httparty'
# Client
class Daemon
  include HTTParty
  base_uri 'localhost:9292'

  def initialize
    @options = {}
  end

  def read
    self.class.get('/api/', @options)
  end

  def run
    for_ever = true
    Thread.new do
      while for_ever
        puts 'i am living'
        sleep 10
      end
    end
  end
end
