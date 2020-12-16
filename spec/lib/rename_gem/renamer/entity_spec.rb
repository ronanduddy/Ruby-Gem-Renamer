# frozen_string_literal: true

require 'support/shared_context/fake_file_system'
require 'support/matchers/directory'
require 'support/matchers/file'

RSpec.describe Renamer::Entity do
  let(:entity) { described_class.new(entity_path) }
  let(:entity_path) { regular_fixtures_dir }
  let(:path) { Renamer::Path }
  let(:stubbed_file_handler) { nil }

  include_context 'fake file system'

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
          let(:entity_path) { "#{regular_fixtures_dir}/dir_hello_world" }
          let(:new_entity_path) { "#{regular_fixtures_dir}/dir_foo_bar" }

          it 'changes directory name' do
            expect(Dir.exist?(entity_path)).to be true
            to
            expect(Dir.exist?(entity_path)).to be false
            expect(Dir.exist?(new_entity_path)).to be true
          end
        end

        context 'a directory whose name is postfixed' do
          let(:entity_path) { "#{regular_fixtures_dir}/hello_world_dir" }
          let(:new_entity_path) { "#{regular_fixtures_dir}/foo_bar_dir" }

          it 'changes directory name' do
            expect(Dir.exist?(entity_path)).to be true
            to
            expect(Dir.exist?(entity_path)).to be false
            expect(Dir.exist?(new_entity_path)).to be true
          end
        end

        context 'a directory whose name is in pascal case' do
          let(:entity_path) { "#{regular_fixtures_dir}/HelloWorld" }
          let(:new_entity_path) { "#{regular_fixtures_dir}/FooBar" }

          it 'changes directory name' do
            expect(Dir.exist?(entity_path)).to be true
            to
            expect(Dir.exist?(entity_path)).to be false
            expect(Dir.exist?(new_entity_path)).to be true
          end
        end
      end

      context 'when entity is a file' do
        let(:entity_path) { regular_fixtures_file('hello_world.rb') }
        let(:stubbed_file_handler) do
          instance_double(Renamer::FileHandler, change: 'changed!')
        end

        before do
          allow(entity).to receive(:file_handler).and_return(stubbed_file_handler)
        end

        it 'runs the file handler for that file' do
          expect(stubbed_file_handler).to receive(:change)
          to
        end
      end
    end
  end

  describe '#directories' do
    subject(:directories) { entity.directories }
    let(:entity_path) { regular_fixtures_dir }

    it 'produces a list of directories' do
      directories.each { |dir| expect(dir).to be_a_directory }
    end
  end

  describe '#files' do
    subject(:files) { entity.files }
    let(:entity_path) { regular_fixtures_dir }

    it 'produces a list of files' do
      files.each { |file| expect(file).to be_a_file }
    end
  end
end
