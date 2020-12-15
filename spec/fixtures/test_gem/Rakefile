# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Push gem to RubyGems.org'
task :release_gem do
  gem = Dir['pkg/*.gem'].max
  sh "gem push #{gem}"
end
