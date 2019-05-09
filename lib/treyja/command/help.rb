module Treyja
  module Command
    class Help
      def run
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
      end
    end
  end
end
