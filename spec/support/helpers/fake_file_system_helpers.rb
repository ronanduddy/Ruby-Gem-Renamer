# frozen_string_literal: true

module Helpers
  module FakeFileSystemHelpers
    require 'fakefs/safe'

    @@default_path = File.expand_path(RSpec.configuration.default_path)

    def fixtures_dir
      "#{@@default_path}/fixtures"
    end

    def regular_fixtures_dir
      "#{fixtures_dir}/regular"
    end

    def regular_fixtures_dir_contents
      Dir["#{regular_fixtures_dir}/**/**"].map do |path|
        path.gsub("#{regular_fixtures_dir}/", '')
      end
    end

    def regular_fixtures_file(file)
      "#{regular_fixtures_dir}/#{file}"
    end

    def test_gem_fixtures_dir
      "#{fixtures_dir}/test_gem"
    end

    def test_gem_fixtures_dir_contents
      Dir["#{test_gem_fixtures_dir}/**/**"].reject { |i| i =~ %r{.git/?.*} }.map do |path|
        path.gsub("#{test_gem_fixtures_dir}/", '')
      end
    end

    def activate_fakefs(dir = nil)
      FakeFS.activate!
      FakeFS::FileSystem.clone(dir || regular_fixtures_dir)
      FakeFS::FileSystem.chdir(dir || regular_fixtures_dir)
    end

    def deactivate_fakefs
      FakeFS.deactivate!
      FakeFS.clear!
    end
  end
end

RSpec.configure do |config|
  config.include Helpers::FakeFileSystemHelpers, :fakefs
end
