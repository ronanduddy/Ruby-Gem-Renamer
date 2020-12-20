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

      def edit(from, to)
        temp_file = Tempfile.new(path.filename)
        changes = false

        file.each_line do |line|
          temp_file.puts replacement(line, from, to)

          changes = true
        rescue StringReplacer::NoMatchError
          temp_file.puts line
        end

        temp_file.close

        if changes
          FileUtils.mv(temp_file.path, path.absolute_path)
          possession.update(file)
        end

        temp_file.unlink

        changes
      end

      def rename(from, to)
        new_filename = replacement(path.filename, from, to)
        built_path = path.build(new_filename)

        File.rename(path.absolute_path, built_path.absolute_path)
        @path = built_path

        true
      rescue StringReplacer::NoMatchError
        false
      end

      private

      def replacement(text, from, to)
        replacer = StringReplacer.new(text)
        replacer.replace(from).with(to)
      end
    end
  end
end
