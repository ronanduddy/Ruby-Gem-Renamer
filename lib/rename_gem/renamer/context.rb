# frozen_string_literal: true

module RenameGem
  module Renamer
    class Context
      attr_reader :from, :to

      def initialize(pwd, target_path, from, to)
        @pwd = pwd
        @target_path = target_path
        @from = from
        @to = to
      end

      def path
        Path.new(@target_path, @pwd)
      end

      def using(new_path)
        self.class.new(@pwd, new_path, from, to)
      end
    end
  end
end
