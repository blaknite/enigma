#!/usr/bin/env ruby

# Usage: ./run.rb encode|decode [options] message
# Options: rotor_order, ring_settings, plug_board, key.
# Defaults: 'I II III', '01 01 01', '', 'AAA'

require File.expand_path('../enigma', __FILE__)
require File.expand_path('../enigma/machine', __FILE__)
require File.expand_path('../enigma/plug_board', __FILE__)
require File.expand_path('../enigma/reflector', __FILE__)
require File.expand_path('../enigma/rotor', __FILE__)

encode_decode = ARGV.shift
message = ARGV.pop
options = Hash[*ARGV.flat_map{ |arg| arg.split('=') }]

case encode_decode
when 'encode'
  puts Enigma::Machine.new(options).encode(message)
when 'decode'
  puts Enigma::Machine.new(options).decode(message)
end
