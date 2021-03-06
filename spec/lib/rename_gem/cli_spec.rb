# frozen_string_literal: true

require 'support/helpers/fake_file_system_helpers'

RSpec.describe CLI do
  let(:cli) { described_class.new }
  let(:remamer) { Renamer }

  describe '#rename' do
    context 'with no args' do
      subject(:rename) { cli.invoke(:rename, []) }

      it 'raises an error' do
        expect { rename }.to raise_error(Thor::RequiredArgumentMissingError)
      end
    end

    context 'with args' do
      subject(:rename) do
        cli.invoke(:rename, [], from: 'hello_world', to: 'foo_bar', path: 'spec/fixtures/hello_world.rb')
      end

      it 'runs the renamer' do
        expect(remamer).to receive(:run)
          .with({ from: 'hello_world', to: 'foo_bar', path: 'spec/fixtures/hello_world.rb' })
        rename
      end
    end
  end

  describe '.start', :fakefs do
    subject(:start) { RenameGem::CLI.start(argv) }
    let(:argv) { ['rename', '-f', from, '-t', to, '-p', path] }
    let(:from) { 'project_name' }
    let(:to) { 'foo_bar' }
    let(:path) { test_gem_fixtures_dir }

    before { activate_fakefs(test_gem_fixtures_dir) }
    after { deactivate_fakefs }

    let(:results) do
      <<~STR
        Edit bin/console
        Edit exe/project_name
        Rename exe/project_name -> foo_bar
        Edit lib/project_name/version.rb
        Rename lib/project_name -> foo_bar
        Edit lib/project_name.rb
        Rename lib/project_name.rb -> foo_bar.rb
        Rename spec/support/lib/project_name -> foo_bar
        Edit spec/spec_helper.rb
        Edit README.md
        Edit docker-compose.yml
        Edit project_name.gemspec
        Rename project_name.gemspec -> foo_bar.gemspec
      STR
    end

    specify { expect { start }.to output(results).to_stdout }
  end
end
