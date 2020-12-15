# frozen_string_literal: true

RSpec.describe Renamer::Modifier do
  let(:modifier) { described_class.new }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  describe '#valid?' do
    subject(:valid?) { modifier.valid? }

    context 'when `from` and `to` nil' do
      it { is_expected.to be false }
    end

    context 'when `to` is nil' do
      before { modifier.from = from }

      it { is_expected.to be false }
    end

    context 'when `from` is nil' do
      before { modifier.to = to }

      it { is_expected.to be false }
    end

    context 'when `from` and `to` are not nil' do
      before do
        modifier.from = from
        modifier.to = to
      end

      it { is_expected.to be true }
    end
  end

  describe '#replacement' do
    subject(:replacement) { modifier.replacement(string) }

    before do
      modifier.from = from
      modifier.to = to
    end

    context 'when `from` cannot be found' do
      let(:string) { 'this is a string' }

      it 'raises an error' do
        expect { replacement }.to raise_error(described_class::ReplacementNotFound)
      end
    end
  end
end
