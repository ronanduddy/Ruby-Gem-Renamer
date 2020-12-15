# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.describe Renamer::Possession do
  let(:possession) { described_class.new(file) }

  describe '#update' do
    subject(:update) { possession.update(other_file) }
    let(:file) { File.new(regular_fixtures_file('hello_world.rb')) }
    let(:other_file) { File.new(regular_fixtures_file('hello_world_no_ext')) }

    let(:stat_mock) { instance_double(File::Stat, mode: 1, uid: 2, gid: 3) }

    before do
      allow(file).to receive(:stat).and_return(stat_mock)
    end

    include_context 'fake file system'

    it 'changes the files owner and permissions' do
      expect(other_file).to receive(:chmod).with(1)
      expect(other_file).to receive(:chown).with(2, 3)
      update
    end
  end
end
