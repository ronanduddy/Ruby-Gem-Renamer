# frozen_string_literal: true

module RenameGem
  module Renamer
    require 'pathname'

    class Path
      attr_reader :path, :pwd

      def initialize(path, pwd)
        @path = path
        @pwd = pwd
      end

      def to_s
        pathname.to_s
      end

      def absolute_path
        Pathname.new(pwd).join(path).to_s
      end

      def filename
        pathname.basename.to_s
      end

      def build(new_path)
        self.class.new(dirname.join(new_path), pwd)
      end

      def directories
        pathname.children.select(&:directory?).sort.map do |pathname|
          self.class.new(pathname.to_s, pwd)
        end
      end

      def files
        pathname.children.select(&:file?).sort.map do |pathname|
          self.class.new(pathname.to_s, pwd)
        end
      end

      def file?
        pathname.file?
      end

      def directory?
        pathname.directory?
      end

      private

      def dirname
        pathname.dirname
      end

      def pathname
        @pathname ||= Pathname.new(path)
      end
    end
  end
end
