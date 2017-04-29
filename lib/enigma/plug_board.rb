module Enigma
  class PlugBoard
    def initialize(plug_pairs)
      @plug_pairs = Hash[*plug_pairs.upcase.split(' ').flat_map{ |pp| [pp[0], pp[1], pp[1], pp[0]] }]
    end

    def encode(c)
      @plug_pairs[c] ? @plug_pairs[c] : c
    end
  end
end
