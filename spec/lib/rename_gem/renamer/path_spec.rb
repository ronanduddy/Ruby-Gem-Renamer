# frozen_string_literal: true

require 'support/shared_context/fake_file_system'
require 'support/matchers/directory'
require 'support/matchers/file'

RSpec.describe Renamer::Path do
  let(:path) { described_class.new(location, pwd) }
  let(:location) { 'files/here/hello_world.rb' }
  let(:pwd) { '/root' }

  include_context 'fake file system'

  describe '#to_s' do
    subject(:to_s) { path.to_s }

    it { is_expected.to eq '/root/files/here/hello_world.rb' }
  end

  describe '#filename' do
    subject(:filename) { path.filename }

    it { is_expected.to eq 'hello_world.rb' }
  end

  describe '#build' do
    subject(:build) { path.build(new_location) }
    let(:new_location) { 'or/here/foo_bar.rb' }

    it 'returns new self with given path appended onto original path' do
      expect(build.to_s).to eq '/root/files/here/or/here/foo_bar.rb'
    end
  end

  describe '#directories' do
    subject(:directories) { path.directories }
    let(:pwd) { regular_fixtures_dir }
    let(:location) { '' }

    it 'returns a list of Paths representing directories' do
      directories.each { |dir| expect(dir).to be_a_directory }
    end
  end

  describe '#files' do
    subject(:files) { path.files }
    let(:pwd) { regular_fixtures_dir }
    let(:location) { '' }

    it 'returns a list of Paths representing files' do
      files.each { |file| expect(file).to be_a_file }
    end
  end

  describe '#file?' do
    subject(:file?) { path.file? }
    let(:pwd) { regular_fixtures_dir }

    context 'when file' do
      let(:location) { 'hello_world.rb' }

      it { is_expected.to be true }
    end

    context 'when directory' do
      let(:location) { 'hello_world_dir' }

      it { is_expected.to be false }
    end
  end

  describe '#directory?' do
    subject(:directory?) { path.directory? }
    let(:pwd) { regular_fixtures_dir }

    context 'when file' do
      let(:location) { 'hello_world.rb' }

      it { is_expected.to be false }
    end

    context 'when directory' do
      let(:location) { 'hello_world_dir' }

      it { is_expected.to be true }
    end
  end
end
