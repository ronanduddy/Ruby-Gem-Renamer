# frozen_string_literal: true

require_relative 'lib/project_name/version'

Gem::Specification.new do |spec|
  spec.name = 'project_name'
  spec.version = ProjectName::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.summary = 'Gem summary'
  spec.description = 'Gem description'
  spec.homepage = 'https://github.com/ronanduddy/project_name'
  spec.license = 'MIT'
  spec.authors = ['Rónán Duddy']
  spec.email = []

  spec.files = []
  spec.bindir = 'bin'
  spec.executables = ['project_name']
  spec.require_path = 'lib'

  spec.required_ruby_version = '>= 3.0.0'

  spec.add_development_dependency 'guard', '~> 2.16', '>= 2.16.2'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.3', '>= 1.3.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.9'
end
