# frozen_string_literal: true

module Enigma
  class Rotor
    AVAILABLE_ROTORS = {
      "I" => { wires: "EKMFLGDQVZNTOWYHXUSPAIBRCJ", notches: %w[Q] },
      "II" => { wires: "AJDKSIRUXBLHWTMCQGZNPYFVOE", notches: %w[E] },
      "III" => { wires: "BDFHJLCPRTXVZNYEIWGAKMUSQO", notches: %w[V] },
      "IV" => { wires: "ESOVPZJAYQUIRHXLNFTGKDCMWB", notches: %w[J] },
      "V" => { wires: "VZBRGITYUPSDNHLXAWMJQOFECK", notches: %w[Z] },
      "VI" => { wires: "JPGVOUMFYQBENHZRDKASXLICTW", notches: %w[Z M] },
      "VII" => { wires: "NZJHGRCXMYSWBOUFAIVLPEKQDT", notches: %w[Z M] },
      "VIII" => { wires: "FKQHTLXOCBJSPDZRAMEWNIUYGV", notches: %w[Z M] }
    }.freeze

    attr_accessor :wires, :notches, :step_count, :ring_setting

    def initialize(type, ring_setting)
      # apply wire configuration and adjust for ring setting
      self.wires = AVAILABLE_ROTORS[type][:wires]
      self.ring_setting = ring_setting
      self.notches = AVAILABLE_ROTORS[type][:notches]
      self.step_count = 0
    end

    def forward_encode(index)
      index = (index + step_count - ring_setting) % ALPHABET.length
      index = ALPHABET.index(wires[index])
      (index - step_count + ring_setting) % ALPHABET.length
    end

    def reverse_encode(index)
      index = (index + step_count - ring_setting) % ALPHABET.length
      index = wires.index(ALPHABET[index])
      (index - step_count + ring_setting) % ALPHABET.length
    end

    # rotate the rotor one step
    def step!
      self.step_count += 1
    end

    # check if this rotor's position is at its notch
    def step_next_rotor?
      notches.include?(ALPHABET[self.step_count % ALPHABET.length])
    end

    private

    def current_offset
      ring_setting + self.step_count
    end
  end
end
