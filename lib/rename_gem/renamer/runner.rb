# frozen_string_literal: true

module RenameGem
  module Renamer
    class Runner
      EXCLUDED_DIRS = ['.git'].freeze

      attr_reader :options

      def initialize(options)
        @options = options
      end

      def run
        context = Context.new(Dir.pwd, options[:path], options[:from], options[:to])
        directory = DirectoryHandler.new(context)

        recurse!(directory)

        # puts context.results
      end

      private

      def recurse!(directory)
        directory.change_files unless excluded_directory?(directory.path)

        directory.directories.each do |sub_directory|
          recurse!(sub_directory)

          sub_directory.rename unless excluded_directory?(sub_directory.path)
        end
      end

      def excluded_directory?(path)
        EXCLUDED_DIRS.include? path.filename
      end
    end
  end
end
