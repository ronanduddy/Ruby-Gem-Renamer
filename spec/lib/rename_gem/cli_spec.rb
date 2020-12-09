# frozen_string_literal: true

RSpec.describe CLI do
  let(:cli) { described_class.new }
  let(:remamer) { Renamer }

  describe '#rename' do
    context 'with no args' do
      subject(:rename) { cli.invoke(:rename, []) }

      it 'raises an error' do
        expect { rename }.to raise_error(
          Thor::RequiredArgumentMissingError,
          "No value provided for required options '--from', '--to'"
        )
      end
    end

    context 'with args' do
      subject(:rename) do
        cli.invoke(:rename, [], from: 'hello_world', to: 'foo_bar')
      end

      it 'runs the renamer' do
        expect(remamer).to receive(:run)
          .with({from: 'hello_world', to: 'foo_bar'}, '/usr/src/app' )
        rename
      end
    end
  end
end
