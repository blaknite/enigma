# frozen_string_literal: true

require "spec_helper"

RSpec.describe Enigma::Rotor do
  let(:rotor) { Enigma::Rotor.new(type, ring_setting) }
  let(:type) { "I" }
  let(:ring_setting) { 0 }

  describe "#forward_encode" do
    context "when a ring setting is not provided" do
      it "should return the encoded index" do
        expect(rotor.forward_encode(0)).to eq Enigma::ALPHABET.index("E")
      end

      context "when the rotor is stepped" do
        before do
          rotor.step!
        end

        it "should return the encoded index" do
          expect(rotor.forward_encode(0)).to eq Enigma::ALPHABET.index("J")
        end
      end
    end

    context "when a ring setting is provided" do
      let(:ring_setting) { 1 } # equivalent to 'B'

      describe "#forward_encode" do
        it "should return the encoded index" do
          expect(rotor.forward_encode(0)).to eq Enigma::ALPHABET.index("K")
        end

        context "when the rotor is stepped" do
          before do
            rotor.step!
          end

          it "should return the encoded index" do
            expect(rotor.forward_encode(0)).to eq Enigma::ALPHABET.index("E")
          end
        end
      end
    end
  end

  describe "#reverse_encode" do
    context "when a ring setting is not provided" do
      it "should return the encoded index" do
        expect(rotor.reverse_encode(Enigma::ALPHABET.index("E"))).to eq 0
      end

      context "when the rotor is stepped" do
        before do
          rotor.step!
        end

        it "should return the encoded index" do
          expect(rotor.reverse_encode(Enigma::ALPHABET.index("J"))).to eq 0
        end
      end
    end

    context "when a ring setting is provided" do
      let(:ring_setting) { 1 } # equivalent to 'B'

      it "should return the encoded index" do
        expect(rotor.reverse_encode(Enigma::ALPHABET.index("K"))).to eq 0
      end

      context "when the rotor is stepped" do
        before do
          rotor.step!
        end

        it "should return the encoded index" do
          expect(rotor.reverse_encode(Enigma::ALPHABET.index("E"))).to eq 0
        end
      end
    end
  end
end
