# frozen_string_literal: true

require 'support/shared_context/fake_file_system'
require 'support/matchers/directory'
require 'support/matchers/file'

RSpec.describe Renamer::Path do
  let(:path) { described_class.new(location) }
  let(:location) { 'files/here/hello_world.rb' }

  describe '#to_s' do
    subject(:to_s) { path.to_s }

    it { is_expected.to eq 'files/here/hello_world.rb' }
  end

  describe '#filename' do
    subject(:filename) { path.filename }

    it { is_expected.to eq 'hello_world.rb' }
  end

  describe '#build' do
    subject(:build) { path.build(new_location) }
    let(:new_location) { 'or/here/foo_bar.rb' }

    it 'returns new self with given path appended onto original path' do
      expect(build.to_s).to eq 'files/here/or/here/foo_bar.rb'
      expect(path.to_s).to eq 'files/here/hello_world.rb'
    end
  end

  describe '#directories' do
    subject(:directories) { path.directories }
    let(:location) { regular_fixtures_dir }

    include_context 'fake file system'

    it 'returns a list of Paths representing directories' do
      directories.each { |dir| expect(dir).to be_a_directory }
    end
  end

  describe '#files' do
    subject(:files) { path.files }
    let(:location) { regular_fixtures_dir }

    include_context 'fake file system'

    it 'returns a list of Paths representing files' do
      files.each { |file| expect(file).to be_a_file }
    end
  end

  describe '#rename' do
    subject(:rename) { path.rename(new_name) }

    include_context 'fake file system'

    context 'when neither file nor directory' do
      let(:location) { "#{regular_fixtures_dir}/no_file" }
      let(:new_name) { "#{regular_fixtures_dir}/new_name" }

      it 'renames the file' do
        expect(File.exist?(location)).to be false
        expect { rename }.to raise_error(described_class::RenameError)
      end
    end

    context 'when file' do
      let(:location) { regular_fixtures_file('hello_world.rb') }
      let(:new_name) { regular_fixtures_file('foo_bar.rb') }

      it 'renames the file' do
        expect(File.exist?(location)).to be true
        rename
        expect(File.exist?(location)).to be false
        expect(File.exist?(regular_fixtures_file('foo_bar.rb'))).to be true
      end
    end

    context 'when directory' do
      let(:location) { regular_fixtures_file('hello_world') }
      let(:new_name) { regular_fixtures_file('foo_bar') }

      it 'renames the file' do
        expect(Dir.exist?(location)).to be true
        rename
        expect(Dir.exist?(location)).to be false
        expect(Dir.exist?(regular_fixtures_file('foo_bar'))).to be true
      end
    end
  end

  describe '#file?' do
    subject(:file?) { path.file? }

    include_context 'fake file system'

    context 'when file' do
      let(:location) { "#{regular_fixtures_dir}/hello_world.rb" }

      it { is_expected.to be true }
    end

    context 'when directory' do
      let(:location) { "#{regular_fixtures_dir}/hello_world_dir" }

      it { is_expected.to be false }
    end
  end

  describe '#directory?' do
    subject(:directory?) { path.directory? }

    include_context 'fake file system'

    context 'when file' do
      let(:location) { "#{regular_fixtures_dir}/hello_world.rb" }

      it { is_expected.to be false }
    end

    context 'when directory' do
      let(:location) { "#{regular_fixtures_dir}/hello_world_dir" }

      it { is_expected.to be true }
    end
  end
end
