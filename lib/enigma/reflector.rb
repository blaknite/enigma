module Enigma
  class Reflector
    AVAILABLE_REFLECTORS = {
      'B'      => 'YRUHQSLDPXNGOKMIEBFZCWVJAT',
      'C'      => 'FVPJIAOYEDRZXWGCTKUQSBNMHL',
      'B_THIN' => 'ENKQAUYWJICOPBLMDXZVFTHRGS',
      'C_THIN' => 'RDOBJNTKVEHMLFCWZAXGYIPSUQ',
    }

    attr_accessor :wires

    def initialize(type)
      self.wires = AVAILABLE_REFLECTORS[type]
    end

    def reflect(index)
      ALPHABET.index(self.wires[index])
    end
  end
end
