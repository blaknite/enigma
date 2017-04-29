#!/usr/bin/env ruby

# Usage: ./run.rb encode|decode [options] message
# Options: rotors, ring_positions, plug_pairs, day_key.
# Defaults: 'I II III', '01 01 01', '', 'AAA'

require File.expand_path('../enigma', __FILE__)
require File.expand_path('../enigma/machine', __FILE__)
require File.expand_path('../enigma/plug_board', __FILE__)
require File.expand_path('../enigma/reflector', __FILE__)
require File.expand_path('../enigma/rotor', __FILE__)

encode_decode = ARGV.shift
message = ARGV.pop
options = Hash[*ARGV.flat_map{ |arg| arg.split('=') }]

machine = Enigma::Machine.new(options)

case encode_decode
when 'encode'
  puts machine.encode(message)
when 'decode'
  puts machine.decode(message)
end
