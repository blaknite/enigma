module Enigma
  class Rotor
    attr_accessor :wires, :notches, :step_count, :ring_setting

    def initialize(type, ring_setting)
      # apply wire configuration and adjust for ring setting
      self.wires = AVAILABLE_ROTORS[type][:wires]
      self.ring_setting = ring_setting
      self.notches = AVAILABLE_ROTORS[type][:notches]
      self.step_count = 0
    end

    def forward_encode(index)
      index = (index + self.step_count - self.ring_setting) % ALPHABET.length
      index = ALPHABET.index(self.wires[index])
      index = (index - self.step_count + self.ring_setting) % ALPHABET.length
      index
    end

    def reverse_encode(index)
      index = (index + self.step_count - self.ring_setting) % ALPHABET.length
      index = self.wires.index(ALPHABET[index])
      index = (index - self.step_count + self.ring_setting) % ALPHABET.length
      index
    end

    # rotate the rotor one step
    def step!
      self.step_count += 1
    end

    # check if this rotor's position is at its notch
    def step_next_rotor?
      self.notches.include?(ALPHABET[self.step_count % ALPHABET.length])
    end

    private

    def current_offset
      self.ring_setting + self.step_count
    end
  end
end
