# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::DirectoryHandler do
  let(:directory_handler) { described_class.new(context) }
  let(:context) { Renamer::Context.new(pwd, path, from, to) }
  let(:pwd) { regular_fixtures_dir }
  let(:path) { 'hello_world.rb' }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  include_context 'fake file system'

  describe '#change_files' do
    subject(:change_files) { directory_handler.change_files }
    let(:path) { '' }

    let(:expected_results) do
      ['Edit .hello_world',
       'Rename .hello_world -> .foo_bar',
       'Edit hello_world.rb',
       'Rename hello_world.rb -> foo_bar.rb',
       'Rename hello_world_empty_spec.rb -> foo_bar_empty_spec.rb',
       'Edit hello_world_no_ext',
       'Rename hello_world_no_ext -> foo_bar_no_ext']
    end

    it 'executes the file handler' do
      change_files
      expect(directory_handler.results).to eq expected_results
    end
  end

  describe '#rename' do
    subject(:rename) { directory_handler.rename }

    context 'when directory cannot be renamed' do
      let(:path) { 'not_real' }

      it 'does not rename the directory and have results' do
        is_expected.to be false
        expect(directory_handler.results).to be_empty
      end
    end

    context 'when directory can be renamed' do
      let(:path) { 'HelloWorld' }

      it 'renames the directory and has results' do
        expect(Dir.exist?(regular_fixtures_file(path))).to be true
        expect(directory_handler.results).to be_empty

        is_expected.to be true

        expect(Dir.exist?(regular_fixtures_file(path))).to be false
        expect(Dir.exist?(regular_fixtures_file('FooBar'))).to be true
        expect(directory_handler.results).to_not be_empty
      end
    end
  end

  describe '#directories' do
    subject(:directories) { directory_handler.directories }
    let(:path) { '' }

    it 'lists a list of directories' do
      directories.each do |dir_path|
        expect(Dir.exist?(dir_path.path.to_s)).to be true
      end
    end
  end
end
