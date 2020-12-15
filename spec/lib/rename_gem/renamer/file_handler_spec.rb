# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::FileHandler do
  let(:file_handler) { described_class.new(path) }
  let(:path) { Renamer::Path.new(location) }
  let(:modifier) { Renamer::Modifier.new(from, to) }

  describe '#change' do
    subject(:change) { file_handler.change(modifier) }
    let(:location) { regular_fixtures_file('hello_world.rb') }

    include_context 'fake file system'

    context 'when valid' do
      let(:from) { 'hello_world' }
      let(:to) { 'foo_bar' }

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

      it 'changes the content of the file' do
        file = File.new(location)
        mode = file.stat.mode
        gid = file.stat.uid
        uid = file.stat.gid

        expect(file.read).to eq content
        expect(file_handler.changes).to eq false

        change

        new_file = File.new(location)
        expect(new_file.read).to eq expected_content
        expect(new_file.stat.mode).to eq mode
        expect(new_file.stat.uid).to eq gid
        expect(new_file.stat.gid).to eq uid
        expect(file_handler.changes).to eq true
      end
    end
  end
end
