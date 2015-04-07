module Enigma
  ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  AVAILABLE_ROTORS = {
    'I'   => { wires: 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', notch: 'Q' },
    'II'  => { wires: 'AJDKSIRUXBLHWTMCQGZNPYFVOE', notch: 'E' },
    'III' => { wires: 'BDFHJLCPRTXVZNYEIWGAKMUSQO', notch: 'V' },
    'IV'  => { wires: 'ESOVPZJAYQUIRHXLNFTGKDCMWB', notch: 'J' },
    'V'   => { wires: 'VZBRGITYUPSDNHLXAWMJQOFECK', notch: 'Z' },
  }
  DEFAULTS = {
    'rotor_order'   => 'I II III',
    'ring_settings' => '01 01 01',
    'plug_board'    => '',
    'key'           => 'AAA',
  }


  class Rotor
    attr_accessor :wires, :notch, :stepping

    def initialize(rotor_settings, ring_setting)
      self.wires = rotor_settings[:wires].chars.each_with_index.map{ |w, i| rotor_settings[:wires][(i + ring_setting) % 26] }.join
      self.notch = rotor_settings[:notch]
      self.stepping = 0
    end

    def forward(c, offset = 0)
      self.wires[(ALPHABET.index(c) + self.stepping - offset) % 26]
    end

    def reverse(c, offset = 0)
      ALPHABET[(@wires.index(c) - self.stepping + offset) % 26]
    end

    def step
      self.stepping += 1
    end

    def step_next_rotor?
      ALPHABET[self.stepping % 26] == self.notch
    end
  end

  class Reflector
    def initialize(wires = nil)
      @wires = wires || 'YRUHQSLDPXNGOKMIEBFZCWVJAT'
    end

    def reflect(c, offset = 0)
      c = @wires[(ALPHABET.index(c) - offset) % 26]
      c = ALPHABET[(ALPHABET.index(c) + offset) % 26]
      return c
    end
  end

  class PlugBoard
    def initialize(settings)
      @plugs = Hash[*settings.upcase.split(' ').map{ |pb| [pb[0], pb[1], pb[1], pb[0]] }.flatten]
    end

    def convert(c)
      @plugs[c] ? @plugs[c] : c
    end
  end

  class Machine
    attr_accessor :rotors

    def initialize(options = {})
      options = DEFAULTS.merge(options)
      options['ring_settings'] = options['ring_settings'].split(' ').map{ |rs| rs.to_i - 1 }

      @rotors = []
      options['rotor_order'].upcase.split(' ').each_with_index do |r, i|
        @rotors << Enigma::Rotor.new(AVAILABLE_ROTORS[r], options['ring_settings'][i])
      end

      @reflector = Enigma::Reflector.new
      @plug_board = Enigma::PlugBoard.new(options['plug_board'])

      set_rotor_stepping(options['key'])
    end


    def encode(string)
      message_key, message_content = split_key_and_message(string)

      encoded_message_key = message_key.chars.map{ |c| encode_character(c) }.join
      set_rotor_stepping(message_key[0..2])

      return encoded_message_key + message_content.chars.map{ |c| encode_character(c) }.join
        .chars.each_with_index.map{ |c, idx| idx % 5 == 0 ? ' ' + c : c }.join
    end

    def decode(string)
      message_key, message_content = split_key_and_message(string)

      set_rotor_stepping(message_key.chars.map{ |c| encode_character(c) }.join[0..2])

      return message_content.chars.map{ |c| encode_character(c) }.join
    end

    private
      def encode_character(c)
        c = c.upcase

        return '' unless ALPHABET.include?(c)

        @rotors[0].step if @rotors[1].step_next_rotor?
        @rotors[1].step if @rotors[2].step_next_rotor?
        @rotors[2].step

        c = @plug_board.convert(c)

        c = @rotors.reverse.each_with_index.inject(c) do |c, (r, i)|
          r.forward(c, @rotors[(@rotors.length - 1 - i) + 1] ? rotors[(@rotors.length - 1 - i) + 1].stepping : 0)
        end

        c = @reflector.reflect(c, @rotors[0].stepping)

        c = @rotors.each_with_index.inject(c) do |c, (r, i)|
          r.reverse(c, @rotors[i + 1] ? rotors[i + 1].stepping : 0)
        end

        c = @plug_board.convert(c)

        return c
      end

      def split_key_and_message(string)
        [string.slice(0..5).upcase, string.slice(6..-1).strip.upcase]
      end

      def set_rotor_stepping(key)
        key.chars.each_with_index{ |c, i| @rotors[i].stepping = ALPHABET.index(c) }
      end
    end
end
