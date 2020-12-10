# frozen_string_literal: true

module RenameGem
  module Renamer
    class Possession
      attr_reader :mode, :uid, :gid

      def initialize(file)
        @mode = file.stat.mode
        @uid = file.stat.uid
        @gid = file.stat.gid
      end

      def update(file)
        file.chmod(mode)
        file.chown(uid, gid)
      end
    end
  end
end
