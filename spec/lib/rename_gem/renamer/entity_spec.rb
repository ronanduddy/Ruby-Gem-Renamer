# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::Entity do
  include_context 'fake file system'

  let(:entity) { described_class.new(context) }
  let(:context) { Renamer::Context.new('/', path, from, to) }
  let(:path) { regular_fixtures_dir }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  describe '#change' do
    subject(:change) { entity.change }

    context 'when entity is a directory' do
      let(:path) { "#{regular_fixtures_dir}/dir_hello_world" }
      let(:new_path) { "#{regular_fixtures_dir}/dir_foo_bar" }
      let(:mocked_directory_handler) do
        instance_double(Renamer::DirectoryHandler, recurse!: 'recursed!')
      end

      it 'runs the directory handler for that directory' do
        expect(Renamer::DirectoryHandler).to receive(:new).and_return(mocked_directory_handler)
        expect(entity.path).to receive(:rename).with("#{regular_fixtures_dir}/dir_foo_bar")
        change
      end
    end

    context 'when entity is a file' do
      let(:path) { regular_fixtures_file('hello_world.rb') }
      let(:mocked_file_handler) do
        instance_double(Renamer::FileHandler, change: 'changed!')
      end

      it 'runs the file handler for that file' do
        expect(Renamer::FileHandler).to receive(:new).and_return(mocked_file_handler)
        expect(entity.path).to receive(:rename).with("#{regular_fixtures_dir}/foo_bar.rb")
        change
      end
    end
  end

  describe '#directories' do
    subject(:directories) { entity.directories }

    it 'produces a list of directories' do
      directories.each do |dir|
        expect(Dir.exist?(dir.path.to_s)).to be true
      end
    end
  end

  describe '#files' do
    subject(:files) { entity.files }

    it 'produces a list of files' do
      files.each do |file|
        expect(File.exist?(file.path.to_s)).to be true
      end
    end
  end
end
