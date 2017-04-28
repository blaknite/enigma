module Enigma
  class PlugBoard
    def initialize(settings)
      @plugs = Hash[*settings.upcase.split(' ').flat_map{ |pb| [pb[0], pb[1], pb[1], pb[0]] }]
    end

    def convert(c)
      @plugs[c] ? @plugs[c] : c
    end
  end
end
