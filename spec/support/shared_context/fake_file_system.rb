# frozen_string_literal: true

require 'support/helpers/fake_file_system_helpers'

RSpec.shared_context 'fake file system', :fakefs do
  before { activate_fakefs }
  after { deactivate_fakefs }
end
