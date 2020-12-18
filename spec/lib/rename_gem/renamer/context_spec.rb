# frozen_string_literal: true

RSpec.describe Renamer::Context do
  let(:context) { described_class.new(pwd, path, from, to) }
  let(:pwd) { '/src/app' }
  let(:path) { 'this/directory' }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  describe '#absolute_path' do
    subject(:absolute_path) { context.absolute_path }

    it { is_expected.to eq '/src/app/this/directory' }
  end

  describe '#as' do
    subject(:as) { context.as('this/other/directory') }

    it { expect(as.path).to eq 'this/other/directory' }
  end
end
