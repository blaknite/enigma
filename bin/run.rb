#! /usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'enigma'

def prompt(question, default = nil)
  print question
  print " [#{default}]" unless default.nil? || default.empty?
  print ': '
  answer = $stdin.gets.chomp
  answer.empty? ? default : answer
end

options = Enigma::Machine::DEFAULTS
options['rotors'] = prompt('Select the rotors', options['rotors'])
options['ring_settings'] = prompt('Provide the ring settings', options['ring_settings'])
options['reflector'] = prompt('Select the reflector', options['reflector'])
options['plug_pairs'] = prompt('Provide the plug pairs', options['plug_pairs'])

encode_decode = prompt('Encode or decode?', 'encode')

message = [prompt('Enter the unique key')]
message << prompt('Enter the message key')
message << prompt('Enter the message')
message = message.join(' ')

machine = Enigma::Machine.new(options)

puts ''

case encode_decode
when 'encode'
  puts machine.encode(message)
when 'decode'
  puts machine.decode(message)
end
