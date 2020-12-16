# frozen_string_literal: true

require 'pathname'
require 'rename_gem/renamer/context'
require 'rename_gem/renamer/directory_handler'
require 'rename_gem/renamer/entity'
require 'rename_gem/renamer/file_handler'
require 'rename_gem/renamer/modifier'
require 'rename_gem/renamer/path'
require 'rename_gem/renamer/possession'
require 'rename_gem/renamer/runner'
require 'rename_gem/renamer/string_replacer'

module RenameGem
  module Renamer
    def self.run(options)
      context = Context.new(Dir.pwd, options[:path], options[:from], options[:to])
      runner = Runner.new(context)
      runner.run
    end
  end
end
