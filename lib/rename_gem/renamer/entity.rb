# frozen_string_literal: true

module RenameGem
  module Renamer
    class Entity
      ChainError = Class.new(StandardError)

      attr_reader :path, :file_handler, :modifier

      def initialize(path, file_handler)
        @path = Path.new(path)
        @file_handler = file_handler
        @modifier = Modifier.new
      end

      def change(from)
        modifier.from = from

        self
      end

      def to(to)
        modifier.to = to

        validate_chaining

        rename
      end

      def directories
        path.directories.map do |directory_path|
          self.class.new(directory_path.to_s, nil)
        end
      end

      def files
        path.files.map do |file_path|
          self.class.new(file_path.to_s, FileHandler.new(file_path))
        end
      end

      private

      def rename
        replacement = modifier.replacement(path.filename)
        new_path = path.build(replacement).to_s

        unless path.to_s == new_path
          file_handler.change(modifier) if path.file?

          path.rename(new_path)
          puts "rename #{path} to #{new_path}"

          @name = nil
          @new_name = nil
        end
      rescue Modifier::ReplacementNotFound => e
        puts "ignoring #{e.message}"
      end

      def validate_chaining
        raise ChainError, "Usage: object.change('x').to('y')" unless modifier.valid?
      end
    end
  end
end
