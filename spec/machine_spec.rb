require 'spec_helper'

RSpec.describe Enigma::Machine do
  let(:machine) { Enigma::Machine.new }

  describe '#encode' do
    let(:message) { 'AAA AAA AAAAA' }

    it 'should encode the message' do
      expect(machine.encode(message)).to eq 'AAA BDZ BDZGO'
    end
  end

  describe '#decode' do
    let(:message) { 'AAA BDZ BDZGO' }

    it 'should decode the message' do
      expect(machine.decode(message)).to eq 'AAA AAA AAAAA'
    end
  end

  describe '#encode_string' do
    let(:string) { 'AAA' }

    it 'should encode the string' do
      expect(machine.encode_string(string)).to eq 'BDZ'
    end
  end

  describe '#encode_character' do
    let(:character) { 'A' }

    context 'when encoding a character' do
      it 'should encode the character' do
        expect(machine.encode_character(character)).to eq('B')
      end

      context 'when encoding the character again' do
        it 'should encode to a different character' do
          expect(machine.encode_character(character)).not_to eq machine.encode_character(character)
        end
      end
    end

    context 'when encoding any character' do
      let(:first_start) { 0 }
      let(:second_start) { 0 }
      let(:third_start) { 0 }

      before do
        machine.first_rotor.step_count  = first_start
        machine.second_rotor.step_count = second_start
        machine.third_rotor.step_count  = third_start
      end

      before do
        machine.encode_character(character)
      end

      context 'at any time' do
        it 'should step the first rotor' do
          expect(machine.first_rotor.step_count).to eq first_start + 1
        end

        it 'should not step the second or third rotor' do
          expect(machine.second_rotor.step_count).to eq second_start
          expect(machine.third_rotor.step_count).to  eq third_start
        end
      end

      context 'when the first rotor is at its notches.first' do
        let(:first_start) { Enigma::ALPHABET.index(machine.first_rotor.notches.first) }

        it 'should step the first and second rotors' do
          expect(machine.first_rotor.step_count).to  eq first_start + 1
          expect(machine.second_rotor.step_count).to eq second_start + 1
        end

        it 'should not step the third rotor' do
          expect(machine.third_rotor.step_count).to eq third_start
        end
      end

      context 'when the second rotor is at its notches.first' do
        let(:second_start) { Enigma::ALPHABET.index(machine.second_rotor.notches.first) }

        it 'should step all rotors' do
          expect(machine.first_rotor.step_count).to  eq first_start + 1
          expect(machine.second_rotor.step_count).to eq second_start + 1
          expect(machine.third_rotor.step_count).to  eq third_start + 1
        end
      end

      context 'when the first and second rotors are at their notches' do
        let(:first_start)  { Enigma::ALPHABET.index(machine.first_rotor.notches.first) }
        let(:second_start) { Enigma::ALPHABET.index(machine.second_rotor.notches.first) }

        it 'should step all rotors' do
          expect(machine.first_rotor.step_count).to  eq first_start + 1
          expect(machine.second_rotor.step_count).to eq second_start + 1
          expect(machine.third_rotor.step_count).to  eq third_start + 1
        end
      end

      context 'when the first rotor is at and the second rotor is before its notches.first' do
        let(:first_start)  { Enigma::ALPHABET.index(machine.first_rotor.notches.first) }
        let(:second_start) { Enigma::ALPHABET.index(machine.second_rotor.notches.first) - 1 }

        it 'should step the first and second rotors' do
          expect(machine.first_rotor.step_count).to  eq first_start + 1
          expect(machine.second_rotor.step_count).to eq second_start + 1
        end

        it 'should not step the third rotor' do
          expect(machine.third_rotor.step_count).to eq third_start
        end

        context 'when encoding any second character' do
          before do
            machine.encode_character(character)
          end

          it 'should step the first and second rotors twice' do
            expect(machine.first_rotor.step_count).to  eq first_start + 2
            expect(machine.second_rotor.step_count).to eq second_start + 2
          end

          it 'should step the third rotor once' do
            expect(machine.third_rotor.step_count).to eq third_start + 1
          end
        end
      end
    end
  end
end
