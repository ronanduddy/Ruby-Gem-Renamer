# frozen_string_literal: true

module RenameGem
  module Renamer
    require 'tempfile'

    class FileHandler
      attr_reader :path, :file, :possession

      def initialize(path)
        @path = path
        @file = File.new(path.to_s)
        @possession = Possession.new(file)
      end

      def change(modifier)
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

        possession.update(file)

        puts "#{lines_changed} lines changed in #{path}"
      end
    end
  end
end
