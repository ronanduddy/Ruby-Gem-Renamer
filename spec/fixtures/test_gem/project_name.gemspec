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
  spec.email = ['dev@ronanduddy.xyz']
  spec.extra_rdoc_files = Dir['README.md', 'LICENSE.md']

  spec.files = Dir['lib/**/*']
  spec.require_paths = %w[lib]

  spec.bindir = 'exe'
  spec.executables = %w[project_name]

  spec.required_ruby_version = '>= 2.7.2'

  spec.add_development_dependency 'guard', '~> 2.16', '>= 2.16.2'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.3', '>= 1.3.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.9'
end
