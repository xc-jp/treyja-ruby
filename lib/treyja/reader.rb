require "treyja/proto/tensors_pb"

module Treyja
  class Reader
    extend Forwardable
    include Enumerable

    delegate [:each] => :@enumerator

    MAGIC_BYTES = "XCIX"

    def initialize file = nil
      io = file ? open(file) : STDIN
      io.binmode

      @enumerator = Enumerator.new do |y|
        while magic = io.read(4)
          raise "Incorrect magic bytes" unless magic == MAGIC_BYTES
          length = io.read(8).reverse.unpack("Q").first.to_i
          y << Tensors::TensorsProto.decode(io.read(length))
        end
      end
    end
  end
end
