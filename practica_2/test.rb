require '.\abstract.rb'

data = AbstractBase.new({name: 'Name', alias: 'alias', link: 'link'})

puts "#{data.by_name("Name")}"