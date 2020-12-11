# frozen_string_literal: true

require 'rename_gem/renamer/runner'
require 'rename_gem/renamer/entity'
require 'rename_gem/renamer/path'
require 'rename_gem/renamer/file_handler'
require 'rename_gem/renamer/directory_handler'
require 'rename_gem/renamer/modifier'
require 'rename_gem/renamer/possession'
require 'rename_gem/renamer/string_replacer'

module RenameGem
  module Renamer
    def self.run(options)
      path = Pathname.new(Dir.pwd).join(options[:path]).to_s
      entity = Entity.new(path, nil)
      runner = RenameGem::Renamer::Runner.new(options[:from], options[:to])
      runner.run(entity)
    end
  end
end
