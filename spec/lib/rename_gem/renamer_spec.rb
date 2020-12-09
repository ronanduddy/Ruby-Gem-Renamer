# frozen_string_literal: true

RSpec.describe Renamer do
  describe '.run' do
    subject(:run) { described_class.run(options, path) }
    let(:options) { { from: 'hello_world', to: 'foo_bar' } }
    let(:path) { '.' }
    let(:traverser) { instance_double(described_class::Traverser, run: 'traversed!') }

    it 'executes the traverser' do
      expect(described_class::Traverser).to receive(:new)
        .with('hello_world', 'foo_bar').and_return(traverser)
      expect(run).to eq 'traversed!'
    end
  end
end
