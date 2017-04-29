module Enigma
  class Reflector
    DEFAULT_WIRES = 'YRUHQSLDPXNGOKMIEBFZCWVJAT'

    def initialize(wires = nil)
      @wires = wires || DEFAULT_WIRES
    end

    def reflect(c, offset = 0)
      c = @wires[(ALPHABET.index(c) - offset) % ALPHABET.length]
      c = ALPHABET[(ALPHABET.index(c) + offset) % ALPHABET.length]
      c
    end
  end
end
