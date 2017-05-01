module Enigma
  class Reflector
    DEFAULT_WIRES = 'YRUHQSLDPXNGOKMIEBFZCWVJAT'

    def initialize(type)
      @wires = AVAILABLE_REFLECTORS[type]
    end

    def reflect(c, offset = 0)
      c = @wires[(ALPHABET.index(c) - offset) % ALPHABET.length]
      c = ALPHABET[(ALPHABET.index(c) + offset) % ALPHABET.length]
      c
    end
  end
end
