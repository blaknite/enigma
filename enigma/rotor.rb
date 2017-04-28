module Enigma
  class Rotor
    attr_accessor :wires, :notch, :stepping, :ring_setting

    def initialize(rotor_settings, ring_setting)
      # apply wire configuration and adjust for ring setting
      self.wires = rotor_settings[:wires].chars.rotate(ring_setting).join
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
      ALPHABET[(self.wires.index(c) - self.stepping + offset) % ALPHABET.length]
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
end
