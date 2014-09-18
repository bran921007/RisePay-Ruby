$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'risepay.rb'

Gem::Specification.new do |s|
  s.name        = 'risepay'
  s.version     = '1.0.2'
  s.date        = '2010-09-08'
  s.summary     = "Risepay API library"
  s.description = "Risepay API library on Ruby"
  s.authors     = ["Francisco Perez","Jhonnatan Rodriguez","Kamel Bacha"]
  s.email       = 'contactus@risepay.com'
  s.files       = ["lib/risepay.rb"]
  s.homepage    =
    'http://www.risepay.com/'
  s.license       = 'risepay'
  

end
