# frozen_string_literal: true

require "spec_helper"

RSpec.describe Enigma::Reflector do
  let(:reflector) { Enigma::Reflector.new(type) }
  let(:type) { "B" }

  describe "#reflect" do
    it "should return the reflected index" do
      expect(reflector.reflect(0)).to eq Enigma::ALPHABET.index("Y")
    end
  end
end
