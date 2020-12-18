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
    let(:entity) { instance_double(described_class::Entity, change: 'chnaged!') }

    it 'executes the traverser' do
      expect(described_class::Entity).to receive(:new).and_return(entity)
      expect(run).to eq 'chnaged!'
    end
  end
end
