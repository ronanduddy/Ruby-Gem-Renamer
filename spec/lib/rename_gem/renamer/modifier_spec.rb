# frozen_string_literal: true

RSpec.describe Renamer::Modifier do
  let(:modifier) { described_class.new(from, to) }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  describe '#replacement' do
    subject(:replacement) { modifier.replacement(string) }

    context 'when `from` cannot be found' do
      let(:string) { 'this is a string' }

      it 'raises an error' do
        expect { replacement }.to raise_error(described_class::ReplacementNotFound)
      end
    end

    context 'when `from` is found' do
      let(:string) { 'hello_world' }

      it { is_expected.to eq 'foo_bar' }
    end
  end
end
