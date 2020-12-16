# frozen_string_literal: true

RSpec.describe Renamer::Context do
  let(:context) { described_class.new(pwd, path, from, to) }
  let(:pwd) { '/src/app' }
  let(:path) { 'this/directory' }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  describe '#full_path' do
    subject(:full_path) { context.full_path }

    it { is_expected.to eq '/src/app/this/directory' }
  end
end
