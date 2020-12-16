# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::Runner do
  let(:runner) { described_class.new(mocked_context) }
  let(:mocked_context) { Renamer::Context.new('/', path, from, to) }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  describe '#run' do
    include_context 'fake file system'

    subject(:run) { runner.run }
    let(:path) { regular_fixtures_dir }

    context 'when a file' do
      let(:path) { regular_fixtures_file('hello_world.rb') }
      let(:entity_mock) do
        instance_double(
          Renamer::Entity,
          to: 'completed!',
          path: double('path', file?: true)
        )
      end

      before do
        allow(entity_mock).to receive(:change).and_return(entity_mock)
      end

      it 'calls the change chain' do
        expect(Renamer::Entity).to receive(:new).and_return(entity_mock)
        expect(entity_mock).to receive(:change)
        expect(entity_mock).to receive(:to)
        run
      end
    end

    context 'when a directory' do
      let(:entity_mock) do
        instance_double(
          Renamer::Entity,
          to: 'completed!',
          path: double('path', file?: false)
        )
      end
      let(:directory_handler_mock) do
        instance_double(Renamer::DirectoryHandler, 'recurse!' => 'recursed!')
      end

      it 'calls the directory handler' do
        expect(Renamer::DirectoryHandler).to receive(:new).and_return(directory_handler_mock)
        expect(directory_handler_mock).to receive(:recurse!)
        is_expected.to eq 'recursed!'
      end
    end
  end
end
