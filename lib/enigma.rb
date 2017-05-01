require 'enigma/machine'
require 'enigma/plug_board'
require 'enigma/reflector'
require 'enigma/rotor'

module Enigma
  ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  AVAILABLE_ROTORS = {
    'I'   => { wires: 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', notch: 'Q' },
    'II'  => { wires: 'AJDKSIRUXBLHWTMCQGZNPYFVOE', notch: 'E' },
    'III' => { wires: 'BDFHJLCPRTXVZNYEIWGAKMUSQO', notch: 'V' },
    'IV'  => { wires: 'ESOVPZJAYQUIRHXLNFTGKDCMWB', notch: 'J' },
    'V'   => { wires: 'VZBRGITYUPSDNHLXAWMJQOFECK', notch: 'Z' },
  }

  AVAILABLE_REFLECTORS = {
    'B' => 'YRUHQSLDPXNGOKMIEBFZCWVJAT',
    'C' => 'FVPJIAOYEDRZXWGCTKUQSBNMHL',
  }
end
