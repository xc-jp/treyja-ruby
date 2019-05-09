require "optparse"

require "treyja/reader"
require "treyja/command/csv"
require "treyja/command/dump"
require "treyja/command/help"
require "treyja/command/image"
require "treyja/command/json"

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

    def run
      if options["help"]
        Treyja::Command::Help.new.run
        return
      end

      patch_round
      case command
      when "dump"
        reader = Treyja::Reader.new file
        Treyja::Command::Dump.new(reader).run
      when "json"
        reader = Treyja::Reader.new file
        Treyja::Command::Json.new(reader).run
      when "image"
        output_dir = options["output"]
        raise "--output option required" unless output_dir

        reader = Treyja::Reader.new file
        Treyja::Command::Image.new(reader, output_dir, options.slice("normalize")).run
      when "csv"
        reader = Treyja::Reader.new file
        Treyja::Command::Csv.new(reader).run
      when nil
        Treyja::Command::Help.new.run
      else
        puts "Unknown command: #{command}"
        Treyja::Command::Help.new.run
      end
    end
  end
end
