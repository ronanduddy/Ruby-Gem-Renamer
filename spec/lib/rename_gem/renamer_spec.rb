# frozen_string_literal: true

RSpec.describe Renamer do
  describe '.run' do
    subject(:run) { described_class.run(options) }
    let(:options) do
      {
        from: 'hello_world',
        to: 'foo_bar',
        path: 'spec/fixtures/hello_world.rb'
      }
    end
    let(:runner) { instance_double(described_class::Runner, run: 'Ran!') }

    it 'executes the traverser' do
      expect(described_class::Runner).to receive(:new).and_return(runner)
      expect(run).to eq 'Ran!'
    end
  end
end
