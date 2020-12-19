# frozen_string_literal: true

module RenameGem
  module Renamer
    class Reporter
      attr_reader :results

      def initialize
        @results = []
      end

      def <<(list)
        results << list
      end

      def print
        results.empty? ? puts('No results, nothing edited or renamed') : puts(results.flatten)
      end
    end
  end
end
