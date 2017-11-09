require_relative './models/user'
require_relative './models/site'
require_relative './models/authentication'

def test_model(tested_class, data)
  t = tested_class.new(*data)
  begin
    t.register
  rescue => ex
    puts "Unexpected Error: #{ex.message}"
  end
  # Se cambio ap ya que no imprimia en la clase
  # ap(tested_class.list_all)
  print t.list_all.to_s

  t.id
end

def test_query(tested_class, data)
  tested_class.new(*data)
end

u_id = test_model(User, ['Cynthia', 'test', 'pez@bincat.mx'])
s_id = test_model(Site, ['bincat', 'bincat.me'])
test_model(Authentication,[u_id, s_id, 'test_cut', 'Th1s154StrongP4$$\/\/0rd'])

#test_query(Site, ['bincat', 'bincat.me'])
