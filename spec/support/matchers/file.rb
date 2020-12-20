# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :be_a_file do
  match do |actual|
    File.exist?(actual.to_s)
  end
end
