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
        edit: true,
        rename: true,
        path: instance_double(Renamer::Path, filename: 'filename.txt')
      )
    end

    it 'executes the file handler' do
      expect(directory_handler.results).to be_empty

      expect(Renamer::FileHandler).to receive(:new)
        .exactly(5).times
        .and_return(mocked_file_handler)
      expect(mocked_file_handler).to receive(:edit).and_return(true)

      change_files

      expect(directory_handler.results.count).to be 10
    end
  end

  describe '#rename' do
    subject(:rename) { directory_handler.rename }

    context 'when directory cannot be renamed' do
      it 'does not rename the directory and have results' do
        is_expected.to be false
        expect(directory_handler.results).to be_empty
      end
    end

    context 'when directory can be renamed' do
      let(:path) { regular_fixtures_file('HelloWorld') }

      it 'renames the directory and has results' do
        expect(Dir.exist?(path)).to be true
        expect(directory_handler.results).to be_empty

        is_expected.to be true

        expect(Dir.exist?(path)).to be false
        expect(Dir.exist?(regular_fixtures_file('FooBar'))).to be true
        expect(directory_handler.results).to_not be_empty
      end
    end
  end

  describe '#directories' do
    subject(:directories) { directory_handler.directories }

    it 'lists a list of directories' do
      directories.each do |dir_path|
        expect(Dir.exist?(dir_path.path.to_s)).to be true
      end
    end
  end
end
