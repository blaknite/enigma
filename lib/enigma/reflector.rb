module Enigma
  class Reflector
    DEFAULT_WIRES = 'YRUHQSLDPXNGOKMIEBFZCWVJAT'

    attr_accessor :wires

    def initialize(type)
      self.wires = AVAILABLE_REFLECTORS[type]
    end

    def reflect(index)
      ALPHABET.index(self.wires[index])
    end
  end
end
