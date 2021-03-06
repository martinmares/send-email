require "option_parser"
require "colorize"
require "log"

module SendEmail
  class ArgParser
    getter :args, :args_multi

    @args : Hash(Symbol, String)
    @args_multi : Hash(Symbol, Array(String))

    def initialize
      @args = Hash(Symbol, String).new
      @args_multi = Hash(Symbol, Array(String)).new
    end

    def parse
      OptionParser.parse do |parser|
        parser.banner = "Usage: send-email [arguments]"
        parser.on("-c CONFIG", "--config=CONFIG", "Specifies the name of the configuration file") do |_config|
          @args[:config] = _config
        end
        parser.on("-a ATTACHMENT", "--attachment=ATTACHMENT", "Attachment file to email (can be set multiple times)") do |_attachment|
          @args_multi[:attachment] = [] of String unless @args_multi.has_key? :attachment
          @args_multi[:attachment] << _attachment
        end
        parser.on("-h", "--help", "Show this help") do
          puts parser
          exit
        end
        parser.invalid_option do |flag|
          puts "#{"Error".colorize(:red)}: #{flag} is not a valid option."
          STDERR.puts parser
          exit(1)
        end
      end

    end

    def check
      unless @args.has_key?(:config)
        puts "#{"Error".colorize(:red)}: config file must be specified (-c CONFIG or --config=CONFIG)."
        exit(1)
      end
    end
  end
end
