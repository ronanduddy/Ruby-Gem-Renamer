# frozen_string_literal: true

require 'support/shared_context/fake_file_system'

RSpec.shared_examples 'file changes' do |file_name, new_file_name|
  include_context 'fake file system'

  let(:entity_path) { "#{fixtures_dir}/#{file_name}" }
  let(:new_entity_path) { "#{fixtures_dir}/#{new_file_name}" }

  it 'changes file content and file name' do
    expect(File.read(entity_path)).to eq content
    expect(File.exist?(entity_path)).to be true
    to
    expect(File.exist?(entity_path)).to be false
    expect(File.read(new_entity_path)).to eq expected_content
    expect(File.exist?(new_entity_path)).to be true
  end
end
