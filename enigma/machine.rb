module Enigma
  class Machine
    DEFAULTS = {
      'rotors'         => 'I II III',
      'ring_positions' => '01 01 01',
      'plug_pairs'     => '',
      'day_key'        => 'AAA',
    }

    attr_reader :rotors, :reflector, :plug_board, :day_key

    def initialize(options = {})
      options = DEFAULTS.merge(options)

      ring_positions = options['ring_positions'].split(' ').map{ |rs| rs.to_i - 1 }
      @rotors = options['rotors'].upcase.split(' ').map.with_index{ |type, i|
        Enigma::Rotor.new(type, ring_positions[i])
      }.reverse!

      @reflector = Enigma::Reflector.new
      @plug_board = Enigma::PlugBoard.new(options['plug_pairs'])
      @day_key = options['day_key']

      reset!
    end

    # encode a message using the day key and its unique key
    def encode(message)
      message = message.upcase

      unique_key, content = split_key_and_content(message)

      apply_key(unique_key)

      content = group_characters(encode_string(content))

      reset!

      encode_string(unique_key) + content
    end

    # decode a message using the day key and its unique key
    def decode(message)
      message = message.upcase

      unique_key, content = split_key_and_content(message)

      unique_key = encode_string(unique_key)

      apply_key(unique_key)

      content = group_characters(encode_string(content))

      unique_key + content
    end

    def reset!
      apply_key(day_key)
    end

    private

    # applies the given key to the machine's rotors
    def apply_key(key)
      fail StandardError, 'key length and rotor count does not match' unless key.length == rotors.length
      key.chars.reverse_each.with_index{ |c, i| rotors[i].step_count = ALPHABET.index(c) }
    end

    # split the message and its unique key - the first word of the message is the key
    def split_key_and_content(string)
      string = string.split(' ')
      [string[0], string[1..-1].join(' ')]
    end

    def encode_string(string)
      string.chars.map{ |c| encode_character(c) }.join
    end

    def encode_character(c)
      return '' unless ALPHABET.include?(c) # only A-Z are valid characters in an encoded message

      # step the rotors before encoding each character
      rotors[2].step if rotors[1].step_next_rotor?
      rotors[1].step if rotors[1].step_next_rotor? || rotors[0].step_next_rotor?
      rotors[0].step

      # encode using plugboard
      c = plug_board.encode(c)

      # encode forward through each rotor
      c = rotors.reduce(c) { |c, r| r.forward_encode(c, safe_rotor_offset(r)) }

      # reflect the character back through the rotors
      c = reflector.reflect(c, rotors.last.offset)

      # encode reverse through all the rotors
      c = rotors.reverse.reduce(c) { |c, r| r.reverse_encode(c, safe_rotor_offset(r)) }

      # encode again using plugboard
      c = plug_board.encode(c)

      c
    end

    def group_characters(string)
      string.chars.map.with_index{ |c, i| i % 5 == 0 ? ' ' + c : c }.join
    end

    def safe_rotor_offset(rotor)
      rotors[rotors.index(rotor) - 1] ? rotors[rotors.index(rotor) - 1].offset : 0
    end
  end
end
