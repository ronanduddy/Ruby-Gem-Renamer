# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :be_a_file do
  match do |actual|
    return File.exist?(actual.path.to_s) if actual.respond_to?(:path)

    File.exist?(actual.to_s)
  end
end
