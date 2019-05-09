module Treyja
  module Command
    class Csv
      attr_reader :reader

      def initialize reader
        @reader = reader
      end

      def run
        if head = reader.first
          headers = head.tensors.each_with_index.flat_map do |t, i|
            dims_to_indices(t.dims).map do |ix|
              [i.to_s, ix.empty? ? nil : ix.reverse.map(&:to_s).join('_')].compact.join('-')
            end
          end
          puts headers.join(',')
          puts head.tensors.flat_map { |t| raw_data(t) }.map(&:to_s).join(',')
          reader.each do |ts|
            puts ts.tensors.flat_map { |t| raw_data(t) }.map(&:to_s).join(',')
          end
        end
      end

      private

      def dims_to_indices dims
        if dims.empty?
          [[]]
        else
          x = dims.first
          xs = dims[1..-1]
          Enumerator.new do |y|
            dims_to_indices(xs).each do |is|
              x.times.each do |i|
                y << [i, *is]
              end
            end
          end
        end
      end

      def raw_data tensor
        case tensor.data_type
        when :INT8, :UINT8
          tensor.byte_data.unpack('C*')
        when :FLOAT
          tensor.float_data
        when :DOUBLE
          tensor.double_data
        else
          raise "unsupported data type: #{tensor.data_type}"
        end
      end
    end
  end
end
