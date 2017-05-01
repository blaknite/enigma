require 'spec_helper'

RSpec.describe Enigma::PlugBoard do
  let(:plug_board) { Enigma::PlugBoard.new(plug_pairs)}
  let(:plug_pairs) { '' }

  describe '#encode' do
    let(:plug_pairs) { 'AB' }

    it 'should return the encoded index' do
      expect(plug_board.encode(Enigma::ALPHABET.index('A'))).to eq Enigma::ALPHABET.index('B')
      expect(plug_board.encode(Enigma::ALPHABET.index('B'))).to eq Enigma::ALPHABET.index('A')
    end
  end
end
