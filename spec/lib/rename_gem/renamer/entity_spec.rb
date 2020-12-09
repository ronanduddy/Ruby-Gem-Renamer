# frozen_string_literal: true

require 'support/shared_context/fake_file_system'
require 'support/shared_examples/directory'
require 'support/shared_examples/file'
require 'support/matchers/directory'
require 'support/matchers/file'

RSpec.describe Renamer::Entity do
  let(:entity) { described_class.new(entity_path) }
  let(:entity_path) { 'placeholder/to/path/' }

  describe '#change' do
    subject(:change) { entity.change(name) }
    let(:name) { 'hello_world' }

    it 'returns self with `name` set for method chaining' do
      expect(entity).to have_attributes(name: nil)
      expect(change).to be_instance_of described_class
      expect(change).to have_attributes(name: 'hello_world')
    end
  end

  describe '#to' do
    subject(:to) { entity.to(new_name) }
    let(:new_name) { 'foo_bar' }

    context 'when `name` is unset' do
      it { expect { to }.to raise_error(described_class::ChainError) }
    end

    context 'when nil is used' do
      let(:new_name) { nil }

      it { expect { to }.to raise_error(described_class::ChainError) }
    end

    context 'with `name` set' do
      before do
        allow(entity).to receive(:name).and_return('hello_world')
      end

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
        let(:entity_path) { 'placeholder/to/path/hello_world.rb' }
        let(:content) do
          <<~STR
            class HelloWorld
              def print_hello_world
                puts 'hello world'
              end
            end
          STR
        end
        let(:expected_content) do
          <<~STR
            class FooBar
              def print_foo_bar
                puts 'hello world'
              end
            end
          STR
        end

        context 'with an empty file having an extension' do
          let(:content) { '' }
          let(:expected_content) { '' }

          include_examples 'file changes', 'hello_world_empty_spec.rb', 'foo_bar_empty_spec.rb'
        end

        context 'with a populated file having an extension' do
          include_examples 'file changes', 'hello_world.rb', 'foo_bar.rb'
        end

        context 'with a populated file having no extension' do
          include_examples 'file changes', 'hello_world_no_ext', 'foo_bar_no_ext'
        end

        context 'with a populated dot/hidden file having no extension' do
          include_examples 'file changes', '.hello_world', '.foo_bar'
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
