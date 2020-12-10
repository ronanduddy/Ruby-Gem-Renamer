# frozen_string_literal: true

module RenameGem
  require 'rename_gem/renamer/traverser'
  require 'rename_gem/renamer/entity'
  require 'rename_gem/renamer/path'
  require 'rename_gem/renamer/file_handler'
  require 'rename_gem/renamer/string_replacer'

  module Renamer
    def self.run(options)
      path = Pathname.new(Dir.pwd).join(options[:path]).to_s
      traverser = RenameGem::Renamer::Traverser.new(options[:from], options[:to])
      traverser.run(path)
    end
  end
end
