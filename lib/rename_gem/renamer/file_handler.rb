# frozen_string_literal: true

module RenameGem
  module Renamer
    require 'tempfile'

    class FileHandler
      attr_reader :path, :file

      def initialize(path)
        @path = path
        @file = File.new(path.to_s)
      end

      def change(modifier)
        permissions = file.stat.mode
        uid = file.stat.uid
        gid = file.stat.gid
        temp_file = Tempfile.new(path.filename)
        lines_changed = 0

        file.each_line do |line|
          temp_file.puts modifier.replacement(line)
          lines_changed += 1
        rescue Modifier::ReplacementNotFound
          temp_file.puts line
        end

        temp_file.close
        FileUtils.mv(temp_file.path, path.to_s) if lines_changed.positive?
        temp_file.unlink

        file.chmod(permissions)
        file.chown(uid, gid)

        puts "#{lines_changed} lines changed in #{path}"
      end
    end
  end
end
