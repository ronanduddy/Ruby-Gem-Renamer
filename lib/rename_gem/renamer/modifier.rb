# frozen_string_literal: true

module RenameGem
  module Renamer
    class Modifier
      ReplacementNotFound = Class.new(StandardError)

      attr_accessor :from, :to

      def initialize(from = nil, to = nil)
        @from = from
        @to = to
      end

      def valid?
        return false if from.nil? || to.nil?

        true
      end

      def replacement(string)
        StringReplacer.new(string).replace(from).with(to)
      rescue StringReplacer::NoMatchError => e
        raise ReplacementNotFound, e.message
      end
    end
  end
end
