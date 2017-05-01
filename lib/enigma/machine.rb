module Enigma
  class Machine
    DEFAULTS = {
      'rotors'         => 'I II III',
      'reflector'      => 'B',
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

      @reflector = Enigma::Reflector.new(options['reflector'])
      @plug_board = Enigma::PlugBoard.new(options['plug_pairs'])
      @day_key = options['day_key']

      reset!
    end

    # encode a message using the day key and its unique key
    def encode(message)
      message = message.upcase

      unique_key, message_key, content = split_keys_and_content(message)

      apply_key(message_key)

      content = group_characters(encode_string(content))

      apply_key(unique_key)

      message_key = encode_string(message_key)

      unique_key + ' ' + message_key + content
    end

    # decode a message using the day key and its unique key
    def decode(message)
      message = message.upcase

      unique_key, message_key, content = split_keys_and_content(message)

      apply_key(unique_key)

      message_key = encode_string(message_key)

      apply_key(message_key)

      content = group_characters(encode_string(content))

      unique_key + ' ' + message_key + content
    end

    def reset!
      apply_key(day_key)
    end

    def left_rotor
      rotors[2]
    end

    def middle_rotor
      rotors[1]
    end

    def right_rotor
      rotors[0]
    end

    private

    # applies the given key to the machine's rotors
    def apply_key(key)
      fail StandardError, 'key length and rotor count does not match' unless key.length == rotors.length
      key.chars.reverse_each.with_index{ |c, i| rotors[i].step_count = ALPHABET.index(c) }
    end

    # split the message and its unique key - the first word of the message is the key
    def split_keys_and_content(string)
      string = string.split(' ')
      [string[0], string[1], string[2..-1].join(' ')]
    end

    def encode_string(string)
      string.chars.map{ |c| encode_character(c) }.join
    end

    def encode_character(c)
      return '' unless ALPHABET.include?(c) # only A-Z are valid characters in an encoded message

      # step the rotors before encoding each character
      step_rotors!

      # encode using plugboard
      c = plug_board.encode(c)

      # encode forward through each rotor
      c = rotors.reduce(c) { |c, r| r.forward_encode(c, offset_for(r)) }

      # reflect the character back through the rotors
      c = reflector.reflect(c, rotors.last.offset)

      # encode reverse through all the rotors
      c = rotors.reverse.reduce(c) { |c, r| r.reverse_encode(c, offset_for(r)) }

      # encode again using plugboard
      c = plug_board.encode(c)

      c
    end

    def step_rotors!
      left_rotor.step!   if middle_rotor.step_next_rotor?
      middle_rotor.step! if middle_rotor.step_next_rotor? && !right_rotor.step_next_rotor?
      middle_rotor.step! if right_rotor.step_next_rotor?
      right_rotor.step!
    end

    def group_characters(string)
      string.chars.map.with_index{ |c, i| i % 5 == 0 ? ' ' + c : c }.join
    end

    def previous_rotor(rotor)
      rotors[rotors.index(rotor) - 1] if rotors.index(rotor) - 1 >= 0
    end

    def step_rotor?(rotor)
      previous_rotor(rotor) ? previous_rotor(rotor).step_next_rotor? : true
    end

    def offset_for(rotor)
      previous_rotor(rotor) ? previous_rotor(rotor).offset : 0
    end
  end
end
