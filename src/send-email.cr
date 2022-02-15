require "email"
require "option_parser"

module SendEmail
  VERSION = "0.1.0"

  class App
    getter :hostname, :port

    @hostname : String
    @port : Int32
    @debug : Bool

    @subject : String
    @text : String
    @html : String

    @from : String
    @recipients : Array(String)

    def run()
        # Create email message
        email = EMail::Message.new
        email.from    "noreply@datalite.cz", "Notify"
        email.to      "mares@datalite.cz"
        email.subject "Test email - hello world!"
        email.message <<-EOM
          Testovací email.

          --
          Martin M.
          EOM

        # Email HTML email body
        email.message_html <<-EOM

        EOM

        # Set SMTP client configuration
        # config = EMail::Client::Config.new("smtp.datalite.cz", 587)
        # config.use_tls(EMail::Client::TLSMode::STARTTLS)
        # config.tls_context.verify_mode = OpenSSL::SSL::VerifyMode::NONE
        config = EMail::Client::Config.new("oracleas.datalite.cz", 2525)

        # Create SMTP client object
        client = EMail::Client.new(config)

        client.start do
          # In this block, default receiver is client
          send(email)
        end
    end

    def initialize()
      @hostname = ""
      @port = -1
      @debug = false

      @subject = ""
      @text = ""
      @html = ""

      @from = ""
      @recipients = [] of String

      _opts = parse_opts()
    end

    def parse_opts
      OptionParser.parse do |parser|
        parser.banner = "Usage: send-email [arguments]"

        parser.on("-h HOSTNAME", "--hostname=HOSTNAME", "Hostname (SMTP)") { |_hostname| @hostname = _hostname }
        parser.on("-p PORT", "--port=PORT", "Port") { |_port| @port = _port.to_i }
        parser.on("-s SUBJECT", "--subject=SUBJECT", "Subject") { |_subject| @subject = _subject }
        parser.on("-f FROM", "--from=FROM", "From:") { |_from| @from = _from }
        parser.on("-r RECIPIENTS", "--recipients=RECIPIENTS", "RcptTo: (comma separated list)") do |_recipients|
          @recipients = _recipients.split(',')
        end
        parser.on("-t TXT", "--txt-body-file=TXT", "Text body file") { |_text| @text = _text }
        parser.on("-m HTML", "--html-body-file=HTML", "Html body file") { |_html| @html = _html }

        parser.on("-d", "--debug", "Debug?") { @debug = true }
        parser.on("-v", "--version", "App version") do
          puts "App name: send-email"
          puts "App version: #{VERSION}"
          exit
        end
        parser.on("-h", "--help", "Show this help") do
          puts parser
          exit
        end
        parser.invalid_option do |flag|
          STDERR.puts "ERROR: #{flag} is not a valid option."
          STDERR.puts parser
          exit(1)
        end

      end
    end

  end

  app = App.new
  app.run

end
