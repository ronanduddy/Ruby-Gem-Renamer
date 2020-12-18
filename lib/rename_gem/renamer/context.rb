# frozen_string_literal: true

module RenameGem
  module Renamer
    class Context
      attr_reader :pwd, :path, :from, :to

      def initialize(pwd, path, from, to)
        @pwd = pwd
        @path = path
        @from = from
        @to = to
      end

      def absolute_path
        Pathname.new(pwd).join(path).to_s
      end

      def as(new_path)
        self.class.new(pwd, new_path, from, to)
      end
    end
  end
end
