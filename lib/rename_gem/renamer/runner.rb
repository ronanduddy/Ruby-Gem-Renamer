# frozen_string_literal: true

module RenameGem
  module Renamer
    class Runner
      attr_reader :context

      def initialize(context)
        @context = context
      end

      def run
        entity = Entity.new(context.full_path)

        if entity.path.file?
          entity.change(context.from).to(context.to)
          return
        end

        DirectoryHandler.new(context.from, context.to).recurse!(entity)
      end
    end
  end
end
