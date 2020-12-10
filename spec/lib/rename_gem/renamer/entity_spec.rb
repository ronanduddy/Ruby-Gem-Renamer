# frozen_string_literal: true

require 'support/shared_context/fake_file_system'
require 'support/shared_examples/directory'
require 'support/shared_examples/file'
require 'support/matchers/directory'
require 'support/matchers/file'

RSpec.describe Renamer::Entity do
  let(:entity) { described_class.new(entity_path, stubbed_file_handler) }
  let(:entity_path) { 'placeholder/to/path/' }
  let(:file_handler) { Renamer::FileHandler }
  let(:path) { Renamer::Path }
  let(:stubbed_file_handler) { nil }

  describe '#change' do
    subject(:change) { entity.change(name) }
    let(:name) { 'hello_world' }

    it 'returns self' do
      expect(entity.modifier.from).to be nil
      expect(change).to be_instance_of described_class
      expect(entity.modifier.from).to eq 'hello_world'
    end
  end

  describe '#to' do
    subject(:to) { entity.to(new_name) }
    let(:new_name) { 'foo_bar' }

    context 'when Entity#change not called first' do
      it { expect { to }.to raise_error(described_class::ChainError) }
    end

    context 'when Entity#change called first' do
      before { entity.change('hello_world') }

      context 'when entity is a directory' do
        context 'a directory whose name is prefixed' do
          include_examples 'directory changes', 'dir_hello_world', 'dir_foo_bar'
        end

        context 'a directory whose name is postfixed' do
          include_examples 'directory changes', 'hello_world_dir', 'foo_bar_dir'
        end

        context 'a directory whose name is in pascal case' do
          include_examples 'directory changes', 'HelloWorld', 'FooBar'
        end
      end

      context 'when entity is a file' do
        let(:entity_path) { fixtures_file('hello_world.rb') }
        let(:file_path) { path.new(entity_path) }
        let(:stubbed_file_handler) { instance_double(file_handler, change: 'changed!') }

        include_context 'fake file system'

        it 'runs the file handler for that file' do
          expect(stubbed_file_handler).to receive(:change)
          to
        end
      end
    end
  end

  describe '#directories' do
    subject(:directories) { entity.directories }
    let(:entity_path) { fixtures_dir }

    include_context 'fake file system'

    it 'produces a list of directories' do
      directories.each { |dir| expect(dir).to be_a_directory }
    end
  end

  describe '#files' do
    subject(:files) { entity.files }
    let(:entity_path) { fixtures_dir }

    include_context 'fake file system'

    it 'produces a list of files' do
      files.each { |file| expect(file).to be_a_file }
    end
  end
end
