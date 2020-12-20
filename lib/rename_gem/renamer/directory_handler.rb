# frozen_string_literal: true

module RenameGem
  module Renamer
    class DirectoryHandler
      attr_reader :context, :path, :results

      def initialize(context)
        @context = context
        @path = Path.new(context.path, context.pwd)
        @results = []
      end

      def change_files
        path.files.each do |pathname|
          file_handler = FileHandler.new(pathname)
          results << "Edit #{pathname.path}" if file_handler.edit(context.from, context.to)
          results << "Rename #{pathname.path} -> #{file_handler.path.filename}" if file_handler.rename(context.from,
                                                                                                       context.to)
        end
      end

      def rename
        built_path = path.build(replacement(path.filename))

        FileUtils.mv(path.to_s, built_path.to_s)

        results << "Rename #{path.path} -> #{built_path.filename}"
        @path = built_path

        true
      rescue StringReplacer::NoMatchError
        false
      end

      def directories
        path.directories.map do |directory_path|
          self.class.new(context.using(directory_path.path))
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
