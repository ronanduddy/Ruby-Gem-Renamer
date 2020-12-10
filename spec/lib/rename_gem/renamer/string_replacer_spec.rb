# frozen_string_literal: true

RSpec.describe Renamer::StringReplacer do
  let(:replacer) { described_class.new(content) }
  let(:content) { "class HelloWorld def print_hello_world puts 'hello world' end end" }

  describe '#replace' do
    subject(:replace) { replacer.replace(text) }
    let(:text) { 'hello_world' }

    it 'returns self with `target` set for method chaining' do
      expect(replacer).to have_attributes(target: nil)
      expect(replace).to be_instance_of described_class
      expect(replace).to have_attributes(target: 'hello_world')
    end
  end

  describe '#with' do
    subject(:with) { replacer.with(text) }
    let(:text) { 'foo_bar' }

    context 'when `target` is unset' do
      it { expect { with }.to raise_error(described_class::ChainError) }
    end

    context 'when nil is used' do
      let(:text) { nil }

      it { expect { with }.to raise_error(described_class::ChainError) }
    end

    context 'when `target` cannot be found in `content`' do
      before { allow(replacer).to receive(:target).and_return('beeblebrox') }

      it { expect { with }.to raise_error(described_class::NoMatchError) }
    end

    context 'when `target` can be found in `content`' do
      let(:expected_content) { "class FooBar def print_foo_bar puts 'hello world' end end" }

      before { allow(replacer).to receive(:target).and_return('hello_world') }

      it 'replaces the old value with a new value in pascal and snake case' do
        is_expected.to eq expected_content
      end
    end

    context 'when `target` can be found multiple times in `content`' do
      let(:content) { "class HelloWorldHelloWorld def print_hello_world_hello_world puts 'hello worldhello world' end end" }
      let(:expected_content) { "class FooBarFooBar def print_foo_bar_foo_bar puts 'hello worldhello world' end end" }

      before { allow(replacer).to receive(:target).and_return('hello_world') }

      it 'replaces the old value with a new value in pascal and snake case' do
        is_expected.to eq expected_content
      end
    end
  end
end
