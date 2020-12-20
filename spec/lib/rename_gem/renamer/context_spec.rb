# frozen_string_literal: true

RSpec.describe Renamer::Context do
  let(:context) { described_class.new(pwd, target_path, from, to) }
  let(:pwd) { '/src/app' }
  let(:target_path) { 'this/directory' }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  describe '#path' do
    subject(:path) { context.path }

    it { is_expected.to be_instance_of Renamer::Path }
  end

  describe '#using' do
    subject(:using) { context.using(new_path) }
    let(:new_path) { 'this/path/here' }

    it { expect(using.path.absolute_path).to eq '/src/app/this/path/here' }
  end
end
