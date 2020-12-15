# frozen_string_literal: true

module RenameGem
  module Renamer
    class DirectoryHandler
      EXCLUDED_DIRS = ['.git'].freeze

      attr_reader :name, :new_name

      def initialize(name, new_name)
        @name = name
        @new_name = new_name
      end

      def recurse!(directory)
        directory.files.each { |file| file.change(name).to(new_name) }

        directory.directories.each do |sub_directory|
          sub_directory.change(name).to(new_name)

          recurse!(sub_directory) unless excluded_directory?(sub_directory)
        end
      end

      private

      def excluded_directory?(dir)
        EXCLUDED_DIRS.include? dir.path.filename
      end
    end
  end
end
