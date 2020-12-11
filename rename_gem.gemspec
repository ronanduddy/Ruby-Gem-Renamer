# frozen_string_literal: true

require_relative 'lib/rename_gem/version'

Gem::Specification.new do |spec|
  spec.name = 'rename_gem'
  spec.version = RenameGem::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.summary = 'A gem that will renames Gems for you'
  spec.description = 'Have a hard time renaming Gems, find it annoying? Hopefully this should help!'
  spec.homepage = 'https://github.com/ronanduddy/Ruby-Gem-Renamer'
  spec.license = 'MIT'
  spec.authors = ['Rónán Duddy']
  spec.email = ['dev@ronanduddy.xyz']

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.require_path = 'lib'
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.required_ruby_version = '>= 2.7.2'
  spec.add_runtime_dependency 'thor', '~> 1.0', '>= 1.0.1'

  spec.add_development_dependency 'fakefs', '~> 1.2', '>= 1.2.3'
  spec.add_development_dependency 'guard', '~> 2.16', '>= 2.16.2'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.3', '>= 1.3.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.9'
end
