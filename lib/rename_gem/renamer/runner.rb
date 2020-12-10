# frozen_string_literal: true

module RenameGem
  module Renamer
    class Runner
      attr_reader :name, :new_name

      def initialize(name, new_name)
        @name = name
        @new_name = new_name
      end

      def run(entity)
        if entity.path.file?
          file = Entity.new(entity.to_s, FileHandler.new(entity.path))
          file.change(name).to(new_name)
          return
        end

        DirectoryHandler.new(name, new_name).recurse!(entity)
      end
    end
  end
end
