# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::Runner do
  let(:runner) { described_class.new(from, to) }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  describe '#run' do
    subject(:run) { runner.run(entity) }
    let(:entity) { Renamer::Entity.new(path, nil) }
    let(:path) { fixtures_dir }

    include_context 'fake file system'

    context 'when a file' do
      let(:path) { fixtures_file('hello_world.rb') }
      let(:entity_mock) { instance_double(Renamer::Entity) }

      before do
        allow(entity_mock).to receive(:change).with(from).and_return(entity_mock)
        allow(entity_mock).to receive(:to).with(to)
      end

      it 'calls the file handler' do
        expect(Renamer::FileHandler).to receive(:new).with(entity.path)
        expect(Renamer::Entity).to receive(:new).and_return(entity_mock)
        expect(entity_mock).to receive(:change).with(from)
        expect(entity_mock).to receive(:to).with(to)
        run
      end
    end

    context 'when a directory' do
      let(:directory_handler_mock) do
        instance_double(Renamer::DirectoryHandler, 'recurse!' => 'recursed!')
      end

      it 'calls the directory handler' do
        expect(Renamer::DirectoryHandler).to receive(:new).with(from, to)
                                                          .and_return(directory_handler_mock)

        expect(directory_handler_mock).to receive(:recurse!).with(entity)
        is_expected.to eq 'recursed!'
      end
    end
  end
end
