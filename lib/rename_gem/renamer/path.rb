# frozen_string_literal: true

module RenameGem
  module Renamer
    require 'pathname'

    class Path
      RenameError = Class.new(StandardError)

      def initialize(path)
        @pathname = Pathname.new(path)
      end

      def to_s
        @pathname.to_s
      end

      def filename
        @pathname.basename.to_s
      end

      def build(new_path)
        self.class.new(dirname.join(new_path))
      end

      def directories
        @pathname.children.select(&:directory?).map do |pathname|
          self.class.new(pathname.to_s)
        end
      end

      def files
        @pathname.children.select(&:file?).map do |pathname|
          self.class.new(pathname.to_s)
        end
      end

      def rename(new_path)
        if file?
          File.rename(to_s, new_path)
        elsif directory?
          FileUtils.mv(to_s, new_path)
        else
          raise RenameError, "#{self} must be a file or a directory"
        end

        puts "Rename #{self} -> #{self.class.new(new_path).filename}"
        @pathname = Pathname.new(new_path)
      end

      def file?
        @pathname.file?
      end

      def directory?
        @pathname.directory?
      end

      private

      def dirname
        @pathname.dirname
      end
    end
  end
end
