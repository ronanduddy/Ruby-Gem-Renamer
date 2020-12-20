# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :be_a_directory do
  match do |actual|
    Dir.exist?(actual.to_s)
  end
end
