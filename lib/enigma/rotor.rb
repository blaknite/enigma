module Enigma
  class Rotor
    attr_accessor :wires, :notches, :step_count, :ring_setting

    def initialize(type, ring_setting)
      # apply wire configuration and adjust for ring setting
      self.wires = AVAILABLE_ROTORS[type][:wires].chars.rotate(ring_setting).join
      self.ring_setting = ring_setting
      self.notches = AVAILABLE_ROTORS[type][:notches]
      self.step_count = 0
    end

    # encode character from right to left of rotor
    # offset comes from parent rotor
    def forward_encode(c, offset)
      self.wires[(ALPHABET.index(c) + self.step_count - offset) % ALPHABET.length]
    end

    # encode character from left to right of rotor
    # offset comes from parent rotor
    def reverse_encode(c, offset)
      ALPHABET[(self.wires.index(c) - self.step_count + offset) % ALPHABET.length]
    end

    # rotate the rotor one step
    def step!
      self.step_count += 1
    end

    # check if this rotor's position is at its notch
    def step_next_rotor?
      self.notches.include?(ALPHABET[self.step_count % ALPHABET.length])
    end

    # the current offset from A
    def offset
      self.step_count - self.ring_setting
    end
  end
end
