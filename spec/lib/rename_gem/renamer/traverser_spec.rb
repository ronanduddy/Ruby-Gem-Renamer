# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::Traverser do
  let(:traverser) { described_class.new(name, new_name) }
  let(:name) { 'hello_world' }
  let(:new_name) { 'foo_bar' }

  describe '#run' do
    subject(:run) { traverser.run(fixtures_dir) }

    include_context 'fake file system'

    context 'with a file' do
      subject(:run) { traverser.run(file) }
      let(:file) { "#{fixtures_dir}/hello_world.rb" }

      it 'renames directories and files' do
        expect(File.exist?(file)).to be true
        run
        expect(File.exist?(file)).to be false
        expect(File.exist?("#{fixtures_dir}/foo_bar.rb")).to be true
      end
    end

    context 'with a directory' do
      let(:pre_structure) do
        ['.hello_world',
         'HelloWorld',
         'HelloWorld/.keep',
         'dir_hello_world',
         'dir_hello_world/.keep',
         'hello_world',
         'hello_world.rb',
         'hello_world/.keep',
         'hello_world_dir',
         'hello_world_dir/.keep',
         'hello_world_empty_spec.rb',
         'hello_world_no_ext',
         'nested_dirs',
         'nested_dirs/hello_world.rb',
         'nested_dirs/nested_hello_world',
         'nested_dirs/nested_hello_world/.keep',
         'nested_dirs/nested_hello_world/hello_world_no_ext']
      end

      let(:post_structure) do
        ['.foo_bar',
         'FooBar',
         'FooBar/.keep',
         'dir_foo_bar',
         'dir_foo_bar/.keep',
         'foo_bar',
         'foo_bar.rb',
         'foo_bar/.keep',
         'foo_bar_dir',
         'foo_bar_dir/.keep',
         'foo_bar_empty_spec.rb',
         'foo_bar_no_ext',
         'nested_dirs',
         'nested_dirs/foo_bar.rb',
         'nested_dirs/nested_foo_bar',
         'nested_dirs/nested_foo_bar/.keep',
         'nested_dirs/nested_foo_bar/foo_bar_no_ext']
      end

      it 'renames directories and files' do
        expect(fixtures_dir_contents).to eq pre_structure
        run
        expect(fixtures_dir_contents).to eq post_structure
      end
    end
  end
end
