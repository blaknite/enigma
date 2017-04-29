module Enigma
  class Machine
    DEFAULTS = {
      'rotors'         => 'I II III',
      'ring_positions' => '01 01 01',
      'plug_pairs'     => '',
      'day_key'        => 'AAA',
    }

    def initialize(options = {})
      options = DEFAULTS.merge(options)

      @rotors = []
      ring_settings = options['ring_settings'].split(' ').map{ |rs| rs.to_i - 1 }.reverse
      options['rotor_order'].upcase.split(' ').reverse.each_with_index do |r, i|
        @rotors << Enigma::Rotor.new(AVAILABLE_ROTORS[r], ring_settings[i])
      end

      @reflector = Enigma::Reflector.new
      @plug_board = Enigma::PlugBoard.new(options['plug_board'])

      @key = options['key']
      reset_rotor_stepping
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
      key.chars.reverse.each_with_index{ |c, i| @rotors[i].stepping = ALPHABET.index(c) }
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
      @rotors[2].step if @rotors[1].step_next_rotor?
      @rotors[1].step if @rotors[1].step_next_rotor? || @rotors[0].step_next_rotor?
      @rotors[0].step

      # encode using plugboard
      c = @plug_board.convert(c)

      # encode forward through each rotor
      c = @rotors.reduce(c) do |c, r|
        r.forward(c, @rotors[@rotors.index(r) - 1] ? @rotors[@rotors.index(r) - 1].offset : 0)
      end

      # reflect the character back through the rotors
      c = @reflector.reflect(c, @rotors[2].offset)

      # encode reverse through all the rotors
      c = @rotors.reverse.reduce(c) do |c, r|
        r.reverse(c, @rotors[@rotors.index(r) - 1] ? @rotors[@rotors.index(r) - 1].offset : 0)
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
