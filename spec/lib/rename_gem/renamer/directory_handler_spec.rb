# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::DirectoryHandler do
  let(:directory_handler) { described_class.new(context) }
  let(:context) { Renamer::Context.new('/', path, from, to) }
  let(:path) { regular_fixtures_dir }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  include_context 'fake file system'

  describe '#change_files' do
    subject(:change_files) { directory_handler.change_files }
    let(:mocked_file_handler) do
      instance_double(
        Renamer::FileHandler,
        edit: 'edited',
        rename: 'renamed'
      )
    end

    it 'executes the file handler' do
      expect(Renamer::FileHandler).to receive(:new)
        .exactly(4).times
        .and_return(mocked_file_handler)
      expect(mocked_file_handler).to receive(:edit).and_return('edited')
      change_files
    end
  end

  describe '#rename' do
    subject(:rename) { directory_handler.rename }
    let(:mocked_path) do
      instance_double(
        Renamer::Path,
        filename: 'hello_world.rb',
        rename: 'renamed'
      )
    end

    before do
      allow(mocked_path).to receive(:build)
    end

    it 'executes rename' do
      expect(Renamer::Path).to receive(:new).and_return(mocked_path)
      expect(mocked_path).to receive(:rename).and_return('renamed')
      rename
    end
  end

  describe '#directories' do
    subject(:directories) { directory_handler.directories }

    it 'lists a list of directories' do
      directories.each do |dir|
        presence = Dir.exist?(dir.path.to_s)
        expect(presence).to be true
      end
    end
  end
end
