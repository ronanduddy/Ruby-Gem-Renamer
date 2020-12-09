# frozen_string_literal: true

module RenameGem
  require 'thor'
  require 'rename_gem/renamer'

  class CLI < Thor
    desc 'rename', 'rename all instances of FROMs to TO for a given file'
    option :from, type: :string, aliases: '-f', required: true, desc: 'the original name'
    option :to, type: :string, aliases: '-t', required: true, desc: 'the new name'
    option :path, type: :string, aliases: '-p', required: true, desc: 'the path to run the renaming'
    def rename
      Renamer.run(options)
    end
  end
end
