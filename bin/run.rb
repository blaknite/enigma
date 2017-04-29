#! /usr/bin/env ruby

# Usage: ./run.rb [options] encode|decode message
# Options: rotors, ring_positions, plug_pairs, day_key.
# Defaults: 'I II III', '01 01 01', '', 'AAA'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'enigma'

message = ARGV.pop
encode_decode = ARGV.pop
options = Hash[*ARGV.flat_map{ |arg| arg.split('=') }]

machine = Enigma::Machine.new(options)

case encode_decode
when 'encode'
  puts machine.encode(message)
when 'decode'
  puts machine.decode(message)
end
