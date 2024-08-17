# frozen_string_literal: true

module Enigma
  class Reflector
    AVAILABLE_REFLECTORS = {
      "B" => "YRUHQSLDPXNGOKMIEBFZCWVJAT",
      "C" => "FVPJIAOYEDRZXWGCTKUQSBNMHL",
      "B_THIN" => "ENKQAUYWJICOPBLMDXZVFTHRGS",
      "C_THIN" => "RDOBJNTKVEHMLFCWZAXGYIPSUQ"
    }.freeze

    attr_accessor :wires

    def initialize(type)
      self.wires = AVAILABLE_REFLECTORS[type]
    end

    def reflect(index)
      ALPHABET.index(wires[index])
    end
  end
end
