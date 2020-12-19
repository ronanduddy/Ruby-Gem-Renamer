# frozen_string_literal: true

RSpec.describe Renamer::Reporter do
  let(:reporter) { described_class.new }

  describe '#<<' do
    subject(:shovel) { reporter << item }
    let(:item) { [1, 2, 3, 4] }

    it 'appends item to `results`' do
      shovel
      expect(reporter.results).to eq [[1, 2, 3, 4]]
    end
  end

  describe '#print' do
    subject(:print) { reporter.print }

    context 'when `results` empty' do
      specify { expect { print }.to output("No results, nothing edited or renamed\n").to_stdout }
    end

    context 'when `results` populated' do
      before do
        reporter << [1, 2]
        reporter << [3, 4]
      end

      let(:results) do
        <<~STR
          1
          2
          3
          4
        STR
      end

      specify { expect { print }.to output(results).to_stdout }
    end
  end
end
