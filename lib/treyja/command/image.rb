require "zlib"

module Treyja
  module Command
    class Image
      attr_reader :reader, :output_dir, :options

      def initialize reader, output_dir, options = {}
        @reader = reader
        @output_dir = output_dir
        @options = options
      end

      def run
        FileUtils.mkdir_p output_dir

        reader.each_with_index do |tensors, i|
          tensors.tensors.each_with_index do |tensor, j|
            n = tensor.dims.drop(3).inject(1, :*) # Drop width, height and channel and fold the rest
            n.times.each do |k|
              postfix = ([i, j] + (n > 1 ? [k] : [])).map(&:to_s).join('-')
              dst = File.join(output_dir, "image-#{postfix}.png")
              write_image tensor, k, dst
            end
          end
        end
        reader.each do |ts|
          p ts
          STDOUT.flush
        end
      end

      private

      def write_image tensor, k, file
        width, height, channel = tensor.dims
        width ||= 1
        height ||= 1
        channel ||= 1
        offset = width * height * channel * k
        range = offset ... (width * height * channel + offset)

        normalizer =
          if options['normalize']
            -> (xs) {
              min, max = xs.minmax
              xs.map { |f| ((f - min) / (max - min) * 255).to_i }
            }
          else
            -> (xs) { xs.map { |f| (f * 255).to_i } }
          end

        depth, org_data =
               case tensor.data_type
               when :UINT8
                 [8, tensor.byte_data.unpack('C*')[range]]
               when :INT8
                 [8, tensor.byte_data.unpack('C*')[range]]
               when :FLOAT
                 [8, normalizer.call(tensor.float_data[range])]
               when :DOUBLE
                 [8, normalizer.call(tensor.double_data[range])]
               else
                 raise "unsupported data type: #{tensor.data_type}"
               end

        color_type =
          case channel
          when 1
            0                         # grayscale
          when 2
            4                         # grayscale and alpha
          when 3
            2                         # rgb
          when 4
            6                         # rgba
          else
            raise "unsupported channel: #{channel}"
          end

        raw_data = (0...height).map do |y|
          (0...width).map do |x|
            (0...channel).map do |ch|
              org_data[ch * height * width + y * width + x]
            end
          end
        end

        def chunk(type, data)
          [data.bytesize, type, data, Zlib.crc32(type + data)].pack("NA4A*N")
        end

        open(file, 'w') do |io|
          io.print "\x89PNG\r\n\x1a\n"
          io.print chunk("IHDR", [width, height, depth, color_type, 0, 0, 0].pack("NNCCCCC"))
          img_data = raw_data.map {|line| ([0] + line.flatten).pack("C*") }.join
          io.print chunk("IDAT", Zlib::Deflate.deflate(img_data))
          io.print chunk("IEND", "")
        end
      end

    end
  end
end
