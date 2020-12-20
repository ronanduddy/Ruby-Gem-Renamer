# frozen_string_literal: true

RSpec.describe Renamer::Context do
  let(:context) { described_class.new(pwd, target_path, from, to) }
  let(:pwd) { '/src/app' }
  let(:target_path) { 'this/directory' }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  describe '#using' do
    subject(:using) { context.using(new_path) }
    let(:new_path) { 'this/path/here' }

    it { expect(using.path).to eq 'this/path/here' }
  end
end
