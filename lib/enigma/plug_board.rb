module Enigma
  class PlugBoard
    def initialize(plug_pairs)
      @plug_pairs = build_plug_pairs(plug_pairs)
    end

    def encode(c)
      @plug_pairs[c] ? @plug_pairs[c] : c
    end

    private

    def build_plug_pairs(plug_pairs)
      plug_pairs.upcase.split(' ').each.with_object({}) do |plug_pair, plug_pairs|
        build_plug_pair(plug_pair, plug_pairs)
      end
    end

    def build_plug_pair(plug_pair, plug_pairs)
      fail StandardError, "plug already connected to #{plug_pair[0]}" if plug_pairs.key?(plug_pair[0])
      fail StandardError, "plug already connected to #{plug_pair[1]}" if plug_pairs.key?(plug_pair[1])
      plug_pairs[plug_pair[0]] = plug_pair[1]
      plug_pairs[plug_pair[1]] = plug_pair[0]
    end
  end
end
