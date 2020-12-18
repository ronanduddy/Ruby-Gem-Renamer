# frozen_string_literal: true

module RenameGem
  module Renamer
    class Entity
      attr_reader :context, :path, :modifier

      def initialize(context)
        @context = context
        @path = Path.new(context.full_path)
        @modifier = Modifier.new(context.from, context.to)
      end

      def change
        if path.file?
          FileHandler.new(path).change(modifier)
        elsif path.directory?
          DirectoryHandler.new(context.from, context.to).recurse!(self)
        end

        new_path = path.build(modifier.replacement(path.filename)).to_s

        path.rename(new_path)
      rescue Modifier::ReplacementNotFound => e
        # nothing
      end

      def directories
        path.directories.map do |directory_path|
          self.class.new(new_context(directory_path))
        end
      end

      def files
        path.files.map do |file_path|
          self.class.new(new_context(file_path))
        end
      end

      private

      def new_context(new_path)
        Context.new(context.pwd, new_path.to_s, context.from, context.to)
      end
    end
  end
end
