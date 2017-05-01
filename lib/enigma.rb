require 'enigma/machine'
require 'enigma/plug_board'
require 'enigma/reflector'
require 'enigma/rotor'

module Enigma
  ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  AVAILABLE_ROTORS = {
    'I'      => { wires: 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', notches: ['Q'] },
    'II'     => { wires: 'AJDKSIRUXBLHWTMCQGZNPYFVOE', notches: ['E'] },
    'III'    => { wires: 'BDFHJLCPRTXVZNYEIWGAKMUSQO', notches: ['V'] },
    'IV'     => { wires: 'ESOVPZJAYQUIRHXLNFTGKDCMWB', notches: ['J'] },
    'V'      => { wires: 'VZBRGITYUPSDNHLXAWMJQOFECK', notches: ['Z'] },
    'VI'     => { wires: 'JPGVOUMFYQBENHZRDKASXLICTW', notches: ['Z', 'M'] },
    'VII'    => { wires: 'NZJHGRCXMYSWBOUFAIVLPEKQDT', notches: ['Z', 'M'] },
    'VIII'   => { wires: 'FKQHTLXOCBJSPDZRAMEWNIUYGV', notches: ['Z', 'M'] },
  }

  AVAILABLE_REFLECTORS = {
    'B'      => 'YRUHQSLDPXNGOKMIEBFZCWVJAT',
    'C'      => 'FVPJIAOYEDRZXWGCTKUQSBNMHL',
    'B_THIN' => 'ENKQAUYWJICOPBLMDXZVFTHRGS',
    'C_THIN' => 'RDOBJNTKVEHMLFCWZAXGYIPSUQ',
  }
end
