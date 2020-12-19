# frozen_string_literal: true

module RenameGem
  module Renamer
    class DirectoryHandler
      attr_reader :context, :path, :results

      def initialize(context)
        @context = context
        @path = Path.new(context.absolute_path)
        @results = []
      end

      def change_files
        path.files.each do |file_path|
          file_handler = FileHandler.new(file_path)

          old_path = file_path.to_s
          results << "Edit #{old_path}" if file_handler.edit(context.from, context.to)
          results << "Rename #{old_path} -> #{file_path.filename}" if file_handler.rename(context.from, context.to)
        end
      end

      def rename
        old_path = path.to_s
        new_path = path.build(replacement(path.filename)).to_s

        results << "Rename #{old_path} -> #{path.filename}" if path.rename(new_path)
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
