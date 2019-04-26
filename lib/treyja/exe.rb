require 'tensors_pb.rb'

class Float
  def self.round_digits
    @round_digits
  end

  def to_s_with_round
    Float.round_digits ?
      self.round(Float.round_digits).to_s_without_round :
      self.to_s_without_round
  end

  alias_method :to_s_without_round, :to_s
  alias_method :to_s, :to_s_with_round
end

module Treyja
  class Exe
    def initialize args
      @args = args
    end

    def options
      unabbrev = {
        'h' => 'help',
        'help' => 'help',
        'output' => 'output',
        'normalize' => 'normalize',
        'round' => 'round'
      }

      @options ||= [
        *@args.map { |k| (ms = k.match(/^--?(\w+)/)) ? [unabbrev[ms[1]], true] : nil },
        *@args.each_cons(2).map { |k, v| (v !~ /^-/ && ms = k.match(/^--?(\w+)/)) ? [unabbrev[ms[1]], v] : nil }
      ].compact.to_h
    end

    def command
      @commmand ||= @args.take_while { |s| s !~ /^-/ }.first
    end

    def file
      @file ||= @args.take_while { |s| s !~ /^-/ }.drop(1).first
    end

    def patch_round
      @round ||= options.fetch('round', 4).to_f
      if @round > 0
        ::Float.instance_variable_set "@round_digits", @round
      end
    end

    def reader
      io = file ? open(file) : STDIN
      io.binmode

      Enumerator.new do |y|
        while magic = io.read(4)
          raise "Incorrect magic bytes" unless magic == 'XCIX'
          length = io.read(8).reverse.unpack("Q").first.to_i
          y << Tensors::TensorsProto.decode(io.read(length))
        end
      end
    end


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

    def run
      if command.nil? || options["help"]
        puts <<EOS
Usage: treyja COMMAND [FILE] [OPTIONS]

  If FILE is not given, it reads from STDIN.

Available options:
  -h,--help                Show this help text
  --output DIR             Directory to output images
  --normalize              Normalize floating values (image only)
  --round INT              Digit to round floating values (default: 4)

Available commands:
  json                     Output tensors in JSON format
  csv                      Output tensors in CSV format
  image                    Create png images and output to DIR
  dump                     Dump in the format of inner expression
EOS
        return
      end

      patch_round
      case command
      when "dump"
        reader.each do |ts|
          p ts
          STDOUT.flush
        end
      when "json"
        reader.each do |ts|
          puts ts.to_json
          STDOUT.flush
        end
      when "image"
        dir = options["output"]
        raise "--output option required" unless dir

        FileUtils.mkdir_p dir

        require "zlib"
        reader.each_with_index do |tensors, i|
          tensors.tensors.each_with_index do |tensor, j|
            n = tensor.dims.drop(3).inject(1, :*) # Drop width, height and channel and fold the rest
            n.times.each do |k|
              postfix = ([i, j] + (n > 1 ? [k] : [])).map(&:to_s).join('-')
              dst = File.join(dir, "image-#{postfix}.png")
              write_image tensor, k, dst
            end
          end
        end
      when "csv"
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
    end
  end
end