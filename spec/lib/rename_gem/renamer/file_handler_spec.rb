# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::FileHandler do
  let(:file_handler) { described_class.new(path) }
  let(:path) { Renamer::Path.new(location) }
  let(:location) { regular_fixtures_file('hello_world.rb') }
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  include_context 'fake file system'

  describe '#edit' do
    subject(:edit) { file_handler.edit(from, to) }

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

    it 'edits the content of the file' do
      file = File.new(location)
      mode = file.stat.mode
      gid = file.stat.uid
      uid = file.stat.gid

      expect(file.read).to eq content
      expect(file_handler.changes).to be false

      edit

      new_file = File.new(location)
      expect(new_file.read).to eq expected_content
      expect(new_file.stat.mode).to eq mode
      expect(new_file.stat.uid).to eq gid
      expect(new_file.stat.gid).to eq uid
      expect(file_handler.changes).to be true
    end
  end

  describe '#rename' do
    subject(:rename) { file_handler.rename(from, to) }

    context 'when file name contains `from`' do
      it 'renames the file' do
        hello_world_presence = File.exist?(regular_fixtures_file('hello_world.rb'))
        expect(hello_world_presence).to be true

        rename

        foo_bar_presence = File.exist?(regular_fixtures_file('foo_bar.rb'))
        expect(foo_bar_presence).to be true

        hello_world_presence = File.exist?(regular_fixtures_file('hello_world.rb'))
        expect(hello_world_presence).to be false
      end
    end

    context 'when file name does not contain `from`' do
      let(:from) { 'blugh' }

      it { expect { rename }.not_to raise_error }
    end
  end
end
