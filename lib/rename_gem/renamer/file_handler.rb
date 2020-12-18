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

      def edit(from, to)
        temp_file = Tempfile.new(path.filename)

        file.each_line do |line|
          temp_file.puts replacement(line, from, to)
          @changes = true
        rescue StringReplacer::NoMatchError
          temp_file.puts line
        end

        temp_file.close

        if @changes
          FileUtils.mv(temp_file.path, path.to_s)
          possession.update(file)
          puts "Edit #{path}"
        end

        temp_file.unlink
      end

      def rename(from, to)
        new_filename = replacement(path.filename, from, to)
        new_path = path.build(new_filename).to_s
        path.rename(new_path)
      rescue StringReplacer::NoMatchError
        # ignore
      end

      private

      def replacement(text, from, to)
        replacer = StringReplacer.new(text)
        replacer.replace(from).with(to)
      end
    end
  end
end
