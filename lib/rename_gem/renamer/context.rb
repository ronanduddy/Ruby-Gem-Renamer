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

      def full_path
        Pathname.new(pwd).join(path).to_s
      end
    end
  end
end
