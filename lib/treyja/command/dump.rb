module Treyja
  module Command
    class Dump
      attr_reader :reader

      def initialize reader
        @reader = reader
      end

      def run
        reader.each do |ts|
          p ts
          STDOUT.flush
        end
      end
    end
  end
end
