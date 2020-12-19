# frozen_string_literal: true

module RenameGem
  module Renamer
    require 'pathname'

    class Path
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
        @pathname.children.select(&:directory?).sort.map do |pathname|
          self.class.new(pathname.to_s)
        end
      end

      def files
        @pathname.children.select(&:file?).sort.map do |pathname|
          self.class.new(pathname.to_s)
        end
      end

      def rename(new_path)
        renamed = false

        if file?
          File.rename(to_s, new_path)
          renamed = true
        elsif directory?
          FileUtils.mv(to_s, new_path)
          renamed = true
        end

        @pathname = Pathname.new(new_path)

        renamed
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
