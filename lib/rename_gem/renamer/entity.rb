# frozen_string_literal: true

module RenameGem
  module Renamer
    class Entity
      ChainError = Class.new(StandardError)

      attr_reader :path, :file_handler, :modifier

      def initialize(path)
        @path = Path.new(path)
        @file_handler = FileHandler.new(@path)
        @modifier = Modifier.new
      end

      def change(from)
        modifier.from = from

        self
      end

      def to(to)
        modifier.to = to

        validate_chaining

        file_handler.change(modifier) if path.file?
        rename
      end

      def directories
        path.directories.map do |directory_path|
          self.class.new(directory_path.to_s)
        end
      end

      def files
        path.files.map do |file_path|
          self.class.new(file_path.to_s)
        end
      end

      private

      def rename
        new_path = path.build(modifier.replacement(path.filename)).to_s

        path.rename(new_path)

        modifier = Modifier.new
      rescue Modifier::ReplacementNotFound => e
        # nothing
      end

      def validate_chaining
        raise ChainError, "Usage: object.change('x').to('y')" unless modifier.valid?
      end
    end
  end
end
