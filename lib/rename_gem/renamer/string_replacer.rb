# frozen_string_literal: true

module RenameGem
  module Renamer
    class StringReplacer
      ChainError = Class.new(StandardError)
      ContentNotFound = Class.new(StandardError)

      attr_reader :content, :target

      def initialize(content)
        @content = content
      end

      def replace(target)
        @target = target

        self
      end

      def with(replacement)
        raise ChainError, "Usage: replacer.replace('x').with('y')" if target.nil? || replacement.nil?
        raise ContentNotFound, "#{target} not found in #{content}" unless exists?(target)

        content.gsub(target, replacement).gsub(pascal_case(target), pascal_case(replacement))
      end

      private

      def exists?(target)
        content.include?(target) || content.include?(pascal_case(target))
      end

      def pascal_case(snake_case)
        snake_case.split('_').map(&:capitalize).join
      end
    end
  end
end
