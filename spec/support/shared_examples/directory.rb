# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.shared_examples 'directory changes' do |dir_name, new_dir_name|
  include_context 'fake file system'

  let(:entity_path) { "#{regular_fixtures_dir}/#{dir_name}" }
  let(:new_entity_path) { "#{regular_fixtures_dir}/#{new_dir_name}" }

  it 'changes directory name' do
    expect(Dir.exist?(entity_path)).to be true
    to
    expect(Dir.exist?(entity_path)).to be false
    expect(Dir.exist?(new_entity_path)).to be true
  end
end
