# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::Runner do
  let(:runner) { described_class.new(options) }
  let(:options) do
    {
      path: regular_fixtures_dir,
      from: from,
      to: to
    }
  end
  let(:from) { 'hello_world' }
  let(:to) { 'foo_bar' }

  include_context 'fake file system'

  describe '#run' do
    subject(:run) { runner.run }

    before { stub_const("#{described_class}::EXCLUDED_DIRS", ['.hidden']) }

    context 'with a directory' do
      let(:pre_structure) do
        ['.hidden',
         '.hidden/hello_world.rb',
         '.hello_world',
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
         'nested_dirs/nested_hello_world/hello_world_no_ext',
         'rubbish.txt']
      end

      let(:post_structure) do
        ['.foo_bar',
         '.hidden',
         '.hidden/hello_world.rb',
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
         'nested_dirs/nested_foo_bar/foo_bar_no_ext',
         'rubbish.txt']
      end

      it 'renames directories and files' do
        expect(regular_fixtures_dir_contents.sort).to eq pre_structure.sort
        run
        expect(regular_fixtures_dir_contents.sort).to eq post_structure.sort
      end
    end
  end
end
