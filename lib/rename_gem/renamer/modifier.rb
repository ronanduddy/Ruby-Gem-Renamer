# frozen_string_literal: true

module RenameGem
  module Renamer
    class Modifier
      ReplacementNotFound = Class.new(StandardError)

      attr_reader :from, :to

      def initialize(from, to)
        @from = from
        @to = to
      end

      def replacement(string)
        StringReplacer.new(string).replace(from).with(to)
      rescue StringReplacer::NoMatchError => e
        raise ReplacementNotFound, e.message
      end
    end
  end
end
