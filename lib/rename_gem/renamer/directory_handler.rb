# frozen_string_literal: true

module RenameGem
  module Renamer
    class DirectoryHandler
      attr_reader :context, :path

      def initialize(context)
        @context = context
        @path = Path.new(context.absolute_path)
      end

      def change_files
        path.files.each do |file_path|
          file_handler = FileHandler.new(file_path)
          file_handler.edit(context.from, context.to)
          file_handler.rename(context.from, context.to)
        end
      end

      def rename
        new_path = path.build(replacement(path.filename)).to_s
        path.rename(new_path)
      rescue StringReplacer::NoMatchError
        # ignore
      end

      def directories
        path.directories.map do |directory_path|
          self.class.new(context.as(directory_path.to_s))
        end
      end

      private

      def replacement(text)
        replacer = StringReplacer.new(text)
        replacer.replace(context.from).with(context.to)
      end
    end
  end
end
