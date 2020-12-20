# frozen_string_literal: true

module RenameGem
  module Renamer
    class DirectoryHandler
      attr_reader :context, :path, :results

      def initialize(context)
        @context = context
        @path = context.path
        @results = []
      end

      def change_files
        path.files.each do |file_path|
          file_handler = FileHandler.new(file_path)

          old_path = file_path.to_s
          results << "Edit #{old_path}" if file_handler.edit(context.from, context.to)
          results << "Rename #{old_path} -> #{file_handler.path.filename}" if file_handler.rename(context.from,
                                                                                                  context.to)
        end
      end

      def rename
        old_path = path.to_s
        built_path = path.build(replacement(path.filename))

        FileUtils.mv(path.absolute_path, built_path.absolute_path)
        @path = built_path
        results << "Rename #{old_path} -> #{built_path.filename}"

        true
      rescue StringReplacer::NoMatchError
        false
      end

      def directories
        path.directories.map do |directory_path|
          self.class.new(context.using(directory_path.to_s))
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
