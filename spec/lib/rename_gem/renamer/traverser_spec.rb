# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::Traverser do
  let(:traverser) { described_class.new(name, new_name) }
  let(:name) { 'hello_world' }
  let(:new_name) { 'foo_bar' }

  describe '#run' do
    subject(:run) { traverser.run(fixtures_dir) }

    include_context 'fake file system'

    let(:pre_structure) do
      ['/usr/src/app/spec/fixtures/.hello_world',
       '/usr/src/app/spec/fixtures/HelloWorld',
       '/usr/src/app/spec/fixtures/HelloWorld/.keep',
       '/usr/src/app/spec/fixtures/dir_hello_world',
       '/usr/src/app/spec/fixtures/dir_hello_world/.keep',
       '/usr/src/app/spec/fixtures/hello_world',
       '/usr/src/app/spec/fixtures/hello_world.rb',
       '/usr/src/app/spec/fixtures/hello_world/.keep',
       '/usr/src/app/spec/fixtures/hello_world_dir',
       '/usr/src/app/spec/fixtures/hello_world_dir/.keep',
       '/usr/src/app/spec/fixtures/hello_world_empty_spec.rb',
       '/usr/src/app/spec/fixtures/hello_world_no_ext',
       '/usr/src/app/spec/fixtures/nested_dirs',
       '/usr/src/app/spec/fixtures/nested_dirs/hello_world.rb',
       '/usr/src/app/spec/fixtures/nested_dirs/nested_hello_world',
       '/usr/src/app/spec/fixtures/nested_dirs/nested_hello_world/.keep',
       '/usr/src/app/spec/fixtures/nested_dirs/nested_hello_world/hello_world_no_ext']
    end

    let(:post_structure) do
      ['/usr/src/app/spec/fixtures/.foo_bar',
       '/usr/src/app/spec/fixtures/FooBar',
       '/usr/src/app/spec/fixtures/FooBar/.keep',
       '/usr/src/app/spec/fixtures/dir_foo_bar',
       '/usr/src/app/spec/fixtures/dir_foo_bar/.keep',
       '/usr/src/app/spec/fixtures/foo_bar',
       '/usr/src/app/spec/fixtures/foo_bar.rb',
       '/usr/src/app/spec/fixtures/foo_bar/.keep',
       '/usr/src/app/spec/fixtures/foo_bar_dir',
       '/usr/src/app/spec/fixtures/foo_bar_dir/.keep',
       '/usr/src/app/spec/fixtures/foo_bar_empty_spec.rb',
       '/usr/src/app/spec/fixtures/foo_bar_no_ext',
       '/usr/src/app/spec/fixtures/nested_dirs',
       '/usr/src/app/spec/fixtures/nested_dirs/foo_bar.rb',
       '/usr/src/app/spec/fixtures/nested_dirs/nested_foo_bar',
       '/usr/src/app/spec/fixtures/nested_dirs/nested_foo_bar/.keep',
       '/usr/src/app/spec/fixtures/nested_dirs/nested_foo_bar/foo_bar_no_ext']
    end

    it 'renames directories and files' do
      expect(fake_file_system).to eq pre_structure
      run
      expect(fake_file_system).to eq post_structure
    end
  end
end
