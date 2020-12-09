# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :be_a_directory do
  match do |actual|
    return Dir.exist?(actual.path.to_s) if actual.respond_to?(:path)

    Dir.exist?(actual.to_s)
  end
end
