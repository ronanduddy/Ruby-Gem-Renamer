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
    let(:mocked_runner) { instance_double(described_class::Runner, run: 'runned') }

    it 'executes the runner' do
      expect(described_class::Runner).to receive(:new).and_return(mocked_runner)
      expect(run).to eq 'runned'
    end
  end
end
