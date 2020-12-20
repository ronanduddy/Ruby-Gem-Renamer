# frozen_string_literal: true

module RenameGem
  module Renamer
    require 'pathname'

    class Path
      attr_reader :path, :pwd

      def initialize(path, pwd)
        @path = Pathname.new(path)
        @pwd = Pathname.new(pwd)
      end

      def to_s
        absolute_path.to_s
      end

      def filename
        absolute_path.basename.to_s
      end

      def build(new_path)
        pathname = path.dirname.join(new_path)
        self.class.new(pathname, pwd)
      end

      def directories
        absolute_path.children.select(&:directory?).sort.map do |pathname|
          self.class.new(relative_path(pathname), pwd)
        end
      end

      def files
        absolute_path.children.select(&:file?).sort.map do |pathname|
          self.class.new(relative_path(pathname), pwd)
        end
      end

      def file?
        absolute_path.file?
      end

      def directory?
        absolute_path.directory?
      end

      private

      def absolute_path
        pwd.join(path)
      end

      def relative_path(pathname)
        pathname.relative_path_from(pwd)
      end
    end
  end
end
