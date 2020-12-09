# frozen_string_literal: true

module RenameGem
  module Renamer
    class Traverser
      attr_reader :name, :new_name

      def initialize(name, new_name)
        @name = name
        @new_name = new_name
      end

      def run(path)
        directory = Entity.new(path)

        change_files(directory)
        recurse!(directory)
      end

      private

      def recurse!(directory)
        directory.directories.each do |sub_directory|
          recurse!(sub_directory)
          change_files(sub_directory)
          sub_directory.change(name).to(new_name)
        end
      end

      def change_files(directory)
        directory.files.each { |file| file.change(name).to(new_name) }
      end
    end
  end
end
