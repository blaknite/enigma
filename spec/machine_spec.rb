require 'spec_helper'
require 'enigma'

RSpec.describe Enigma::Machine do
  let(:machine) { Enigma::Machine.new }

  describe '#step_rotors' do
    let(:right_start)  { 0 }
    let(:middle_start) { 0 }
    let(:left_start)   { 0 }

    before do
      machine.right_rotor.step_count  = right_start
      machine.middle_rotor.step_count = middle_start
      machine.left_rotor.step_count   = left_start

      machine.send(:step_rotors!)
    end

    context 'at any time' do
      it 'should step the right rotor' do
        expect(machine.right_rotor.step_count).to eq right_start + 1
      end

      it 'should not step the middle or left rotor' do
        expect(machine.middle_rotor.step_count).to eq middle_start
        expect(machine.left_rotor.step_count).to   eq left_start
      end
    end

    context 'when the right rotor is at its notch' do
      let(:right_start) { Enigma::ALPHABET.index(machine.right_rotor.notch) }

      it 'should step the right and middle rotors' do
        expect(machine.right_rotor.step_count).to  eq right_start + 1
        expect(machine.middle_rotor.step_count).to eq middle_start + 1
      end

      it 'should not step the left rotor' do
        expect(machine.left_rotor.step_count).to eq left_start
      end
    end

    context 'when the middle rotor is at its notch' do
      let(:middle_start) { Enigma::ALPHABET.index(machine.middle_rotor.notch) }

      it 'should step all rotors' do
        expect(machine.right_rotor.step_count).to  eq right_start + 1
        expect(machine.middle_rotor.step_count).to eq middle_start + 1
        expect(machine.left_rotor.step_count).to   eq left_start + 1
      end
    end

    context 'when the right and middle rotors are at their notches' do
      let(:right_start)  { Enigma::ALPHABET.index(machine.right_rotor.notch) }
      let(:middle_start) { Enigma::ALPHABET.index(machine.middle_rotor.notch) }

      it 'should step all rotors' do
        expect(machine.right_rotor.step_count).to  eq right_start + 1
        expect(machine.middle_rotor.step_count).to eq middle_start + 1
        expect(machine.left_rotor.step_count).to   eq left_start + 1
      end
    end

    context 'when the right rotor is at and the middle rotor is before its notch' do
      let(:right_start)  { Enigma::ALPHABET.index(machine.right_rotor.notch) }
      let(:middle_start) { Enigma::ALPHABET.index(machine.middle_rotor.notch) - 1 }

      it 'should step the right and middle rotors' do
        expect(machine.right_rotor.step_count).to  eq right_start + 1
        expect(machine.middle_rotor.step_count).to eq middle_start + 1
      end

      it 'should not step the left rotor' do
        expect(machine.left_rotor.step_count).to eq left_start
      end

      context 'when stepped twice' do
        before do
          machine.send(:step_rotors!)
        end

        it 'should step the right and middle rotors twice' do
          expect(machine.right_rotor.step_count).to  eq right_start + 2
          expect(machine.middle_rotor.step_count).to eq middle_start + 2
        end

        it 'should step the left rotor once' do
          expect(machine.left_rotor.step_count).to eq left_start + 1
        end
      end
    end
  end
end
