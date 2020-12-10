# frozen_string_literal: true

module RenameGem
  module Renamer
    class Entity
      ChainError = Class.new(StandardError)
      Modifier = Struct.new(:from, :to)

      attr_reader :path, :file_handler, :name, :new_name

      def initialize(path, file_handler)
        @path = Path.new(path)
        @file_handler = file_handler
      end

      def change(name)
        @name = name

        self
      end

      def to(new_name)
        raise ChainError, "Usage: object.change('x').to('y')" if name.nil? || new_name.nil?

        @new_name = new_name

        rename
      end

      def directories
        path.directories.map do |directory_path|
          self.class.new(directory_path.to_s, nil)
        end
      end

      def files
        path.files.map do |file_path|
          self.class.new(file_path.to_s, FileHandler.new(file_path))
        end
      end

      private

      def rename
        replacement = replace(path.filename)
        new_path = path.build(replacement).to_s

        unless path.to_s == new_path
          file_handler.change(Modifier.new(name, new_name)) if path.file?

          path.rename(new_path)
          puts "rename #{path} to #{new_path}"

          @name = nil
          @new_name = nil
        end
      rescue StringReplacer::ContentNotFound => e
        puts "ignoring #{e.message}"
      end

      def replace(content)
        StringReplacer.new(content).replace(name).with(new_name)
      end
    end
  end
end
