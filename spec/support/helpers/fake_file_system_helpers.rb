# frozen_string_literal: true

module Helpers
  module FakeFileSystemHelpers
    require 'fakefs/safe'

    @@default_path = File.expand_path(RSpec.configuration.default_path)

    def fixtures_dir
      "#{@@default_path}/fixtures"
    end

    def activate_fakefs
      FakeFS.activate!
      FakeFS::FileSystem.clone(fixtures_dir)
    end

    def deactivate_fakefs
      FakeFS.deactivate!
      FakeFS.clear!
    end

    def fixtures_dir_contents
      Dir["#{fixtures_dir}/**/**"].map do |path|
        path.gsub("#{fixtures_dir}/", '')
      end
    end

    def fixtures_file(file)
      "#{fixtures_dir}/#{file}"
    end
  end
end

RSpec.configure do |config|
  config.include Helpers::FakeFileSystemHelpers, :fakefs
end
