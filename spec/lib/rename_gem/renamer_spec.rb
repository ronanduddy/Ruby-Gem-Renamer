# frozen_string_literal: true

RSpec.describe Renamer do
  describe '.run' do
    subject(:run) { described_class.run(options) }
    let(:options) { { from: 'hello_world', to: 'foo_bar', path: 'spec/fixtures/hello_world.rb' } }
    let(:runner) { instance_double(described_class::Runner, run: 'Ran!') }

    it 'executes the traverser' do
      expect(described_class::Runner).to receive(:new)
        .with('hello_world', 'foo_bar').and_return(runner)
      expect(run).to eq 'Ran!'
    end
  end
end
