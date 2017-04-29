module Enigma
  ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  AVAILABLE_ROTORS = {
    'I'   => { wires: 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', notch: 'Q' },
    'II'  => { wires: 'AJDKSIRUXBLHWTMCQGZNPYFVOE', notch: 'E' },
    'III' => { wires: 'BDFHJLCPRTXVZNYEIWGAKMUSQO', notch: 'V' },
    'IV'  => { wires: 'ESOVPZJAYQUIRHXLNFTGKDCMWB', notch: 'J' },
    'V'   => { wires: 'VZBRGITYUPSDNHLXAWMJQOFECK', notch: 'Z' },
  }
  DEFAULTS = {
    'rotor_order'   => 'I II III',
    'ring_settings' => '01 01 01',
    'plug_board'    => '',
    'key'           => 'AAA',
  }
end
