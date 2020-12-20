# frozen_string_literal: true

module RenameGem
  module Renamer
    class Context
      attr_reader :from, :to, :pwd, :path

      def initialize(pwd, path, from, to)
        @pwd = pwd
        @path = path
        @from = from
        @to = to
      end

      def using(new_path)
        self.class.new(pwd, new_path, from, to)
      end
    end
  end
end
