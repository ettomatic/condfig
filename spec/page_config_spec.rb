require 'spec_helper'

module Condfig
  describe PageConfig do
    let(:data) do
      {
        'id'    => 'foo',
        'value' => 'some value'
      }
    end

    subject { described_class.new(data) }

    describe '#id' do
      it 'returns the page id' do
        expect(subject.id).to eq('foo')
      end
    end

    describe '#valid?' do
      context 'when data is missing' do
        let(:data) { nil }

        it 'return false' do
          expect(subject.valid?).to be false
        end
      end

      context 'when data is not valid' do
        let(:data) { 'abc' }

        it 'return false' do
          expect(subject.valid?).to be false
        end
      end

      context 'when key is missing' do
        it 'return false' do
          expect(subject.valid?(x: 123)).to be false
        end
      end

      context 'when value is not valid' do
        it 'return false' do
          expect(subject.valid?(id: 'bar')).to be false
        end
      end

      context 'when value is valid' do
        it 'return true' do
          expect(subject.valid?(id: 'foo')).to be true
        end
      end
    end

    describe '#as_json' do
      it 'returns a json representation' do
        expect(subject.as_json).to eq(data.to_json)
      end
    end
  end
end
