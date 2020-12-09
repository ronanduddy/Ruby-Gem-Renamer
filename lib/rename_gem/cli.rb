# frozen_string_literal: true

module RenameGem
  require 'thor'
  require 'rename_gem/renamer'

  class CLI < Thor
    desc 'rename', 'rename all instances of FROM to TO regardless of case.'
    option :from, type: :string, required: true
    option :to, type: :string, required: true
    def rename
      path = Dir.pwd
      Renamer.run(options, path)
    end
  end
end
