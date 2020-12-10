# frozen_string_literal: true

module RenameGem
  module Renamer
    class DirectoryHandler
      attr_reader :name, :new_name

      def initialize(name, new_name)
        @name = name
        @new_name = new_name
      end

      def recurse!(directory)
        directory.files.each { |file| file.change(name).to(new_name) }

        directory.directories.each do |sub_directory|
          sub_directory.change(name).to(new_name)

          recurse!(sub_directory)
        end
      end
    end
  end
end
