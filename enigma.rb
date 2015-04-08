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
    attr_accessor :wires, :notch, :stepping, :ring_setting

    def initialize(rotor_settings, ring_setting)
      # apply wire configuration and adjust for ring setting
      self.wires = rotor_settings[:wires].chars.each_with_index.map{ |w, i| rotor_settings[:wires][(i - ring_setting) % ALPHABET.length] }.join
      self.ring_setting = ring_setting
      self.notch = rotor_settings[:notch]
      self.stepping = 0
    end

    # encode character from right to left of rotor
    # offset comes from parent rotor
    def forward(c, offset = 0)
      self.wires[(ALPHABET.index(c) + self.stepping - offset) % ALPHABET.length]
    end

    # encode character from left to right of rotor
    # offset comes from parent rotor
    def reverse(c, offset = 0)
      ALPHABET[(@wires.index(c) - self.stepping + offset) % ALPHABET.length]
    end

    # rotate the rotor one step
    def step
      self.stepping += 1
    end

    # check if this rotor's position is at its notch
    def step_next_rotor?
      ALPHABET[self.stepping % ALPHABET.length] == self.notch
    end

    # the current offset from A
    def offset
      self.stepping - self.ring_setting
    end
  end

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

      @key = options['key']
      @rotors = []
      options['rotor_order'].upcase.split(' ').each_with_index do |r, i|
        @rotors << Enigma::Rotor.new(AVAILABLE_ROTORS[r], options['ring_settings'][i])
      end

      @reflector = Enigma::Reflector.new
      @plug_board = Enigma::PlugBoard.new(options['plug_board'])

      set_rotor_stepping(options['key'])
    end

    # encode a message using the day key and its unique key
    def encode(string)
      message_key, message_content = split_key_and_message(string)

      encoded_message_key = message_key.chars.map{ |c| encode_character(c) }.join
      set_rotor_stepping(message_key[0..2])

      return encoded_message_key + message_content.chars.map{ |c| encode_character(c) }.join
        .chars.each_with_index.map{ |c, idx| idx % 5 == 0 ? ' ' + c : c }.join
    end

    # decode a message using the day key and its unique key
    def decode(string)
      message_key, message_content = split_key_and_message(string)

      decoded_message_key = message_key.chars.map{ |c| encode_character(c) }.join
      set_rotor_stepping(decoded_message_key[0..2])

      return decoded_message_key + ' ' + message_content.chars.map{ |c| encode_character(c) }.join
    end

    # sets the rotor stepping to match a given key
    def set_rotor_stepping(key)
      key.chars.each_with_index{ |c, i| @rotors[i].stepping = ALPHABET.index(c) }
    end

    # resets the rotor stepping to the 'day key'
    def reset_rotor_stepping
      set_rotor_stepping(@key)
    end

    private
      def encode_character(c)
        c = c.upcase

        return '' unless ALPHABET.include?(c) # only A-Z are valid characters in an encoded message

        # step the rotors before encoding each character
        @rotors[0].step if @rotors[1].step_next_rotor?
        @rotors[1].step if @rotors[1].step_next_rotor? || @rotors[2].step_next_rotor?
        @rotors[2].step

        # encode using plugboard
        c = @plug_board.convert(c)

        # encode forward through each rotor
        c = @rotors.reverse.inject(c) do |c, r|
          r.forward(c, @rotors[@rotors.index(r) + 1] ? rotors[@rotors.index(r) + 1].offset : 0)
        end

        # reflect the character back through the rotors
        c = @reflector.reflect(c, @rotors[0].offset)

        # encode reverse through all the rotors
        c = @rotors.inject(c) do |c, r|
          r.reverse(c, @rotors[@rotors.index(r) + 1] ? rotors[@rotors.index(r) + 1].offset : 0)
        end

        # encode again using plugboard
        c = @plug_board.convert(c)

        return c
      end

      # split the message and its unique key because they come in the format "aaaaaa this is a test"
      def split_key_and_message(string)
        [string.slice(0..5).upcase, string.slice(6..-1).strip.upcase]
      end
    end
end
