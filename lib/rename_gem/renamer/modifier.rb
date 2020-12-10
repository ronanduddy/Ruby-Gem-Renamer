# frozen_string_literal: true

module RenameGem
  module Renamer
    class Modifier
      ReplacementNotFound = Class.new(StandardError)

      attr_accessor :from, :to
      attr_reader :times_replaced

      def initialize(from = nil, to = nil)
        @from = from
        @to = to
        @times_replaced = 0
      end

      def valid?
        return false if from.nil? || to.nil?

        true
      end

      def replacement(string)
        replacer = StringReplacer.new(string)
        content = replacer.replace(from).with(to)
        @times_replaced += 1

        content
      rescue StringReplacer::NoMatchError => e
        raise ReplacementNotFound, e.message
      end
    end
  end
end
