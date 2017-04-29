module Enigma
  ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  AVAILABLE_ROTORS = {
    'I'   => { wires: 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', notch: 'Q' },
    'II'  => { wires: 'AJDKSIRUXBLHWTMCQGZNPYFVOE', notch: 'E' },
    'III' => { wires: 'BDFHJLCPRTXVZNYEIWGAKMUSQO', notch: 'V' },
    'IV'  => { wires: 'ESOVPZJAYQUIRHXLNFTGKDCMWB', notch: 'J' },
    'V'   => { wires: 'VZBRGITYUPSDNHLXAWMJQOFECK', notch: 'Z' },
  }
end
