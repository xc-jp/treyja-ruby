module Treyja
  module Command
    class Json
      attr_reader :reader

      def initialize reader
        @reader = reader
      end

      def run
        reader.each do |ts|
          puts ts.to_json
          STDOUT.flush
        end
      end
    end
  end
end
