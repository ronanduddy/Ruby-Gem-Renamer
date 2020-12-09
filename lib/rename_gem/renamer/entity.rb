# frozen_string_literal: true

module RenameGem
  module Renamer
    class Entity
      ChainError = Class.new(StandardError)

      attr_reader :path, :name, :new_name

      def initialize(path)
        @path = Path.new(path)
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
          self.class.new(directory_path.to_s)
        end
      end

      def files
        path.files.map do |file_path|
          self.class.new(file_path.to_s)
        end
      end

      private

      def rename
        replacement = replace(path.filename)
        new_path = path.build(replacement).to_s

        unless path.to_s == new_path
          modify if path.file?

          path.rename(new_path)
          puts "rename #{path} to #{new_path}"

          @name = nil
          @new_name = nil
        end
      rescue StringReplacer::ContentNotFound => e
        puts "ignoring #{e.message}"
      end

      def modify
        require 'tempfile'

        file = File.new(path.to_s)
        permissions = file.stat.mode
        uid = file.stat.uid
        gid = file.stat.gid
        temp_file = Tempfile.new(path.filename)
        lines_changed = 0

        file.each_line do |line|
          temp_file.puts replace(line)
          lines_changed += 1
        rescue StringReplacer::ContentNotFound => e
          temp_file.puts line
        end

        temp_file.close
        FileUtils.mv(temp_file.path, path.to_s) if lines_changed.positive?
        temp_file.unlink

        file.chmod(permissions)
        file.chown(uid, gid)

        puts "#{lines_changed} lines changed in #{path}"
      end

      def replace(content)
        StringReplacer.new(content).replace(name).with(new_name)
      end
    end
  end
end
