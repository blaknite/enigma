module Enigma
  class Reflector
    def initialize(wires = nil)
      @wires = wires || 'YRUHQSLDPXNGOKMIEBFZCWVJAT'
    end

    def reflect(c, offset = 0)
      c = @wires[(ALPHABET.index(c) - offset) % ALPHABET.length]
      c = ALPHABET[(ALPHABET.index(c) + offset) % ALPHABET.length]
      return c
    end
  end
end
