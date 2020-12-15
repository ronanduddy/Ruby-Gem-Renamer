# frozen_string_literal: true

module RenameGem
  module Renamer
    require 'tempfile'

    class FileHandler
      attr_reader :path, :file, :possession, :changes

      def initialize(path)
        @path = path
        @file = File.new(path.to_s)
        @possession = Possession.new(file)
        @changes = false
      end

      def change(modifier)
        temp_file = Tempfile.new(path.filename)

        file.each_line do |line|
          temp_file.puts modifier.replacement(line)
          @changes = true
        rescue Modifier::ReplacementNotFound
          temp_file.puts line
        end

        temp_file.close
        FileUtils.mv(temp_file.path, path.to_s) if @changes
        temp_file.unlink

        possession.update(file)
      end
    end
  end
end
