require "email"
require "option_parser"

require "../src/arg_parser"
require "../src/config"

module SendEmail
  VERSION = "0.1.0"

  class App
    getter :config

    @config : Config
    @arg_pars : ArgParser

    def initialize()
      @arg_pars = ArgParser.new
      @arg_pars.parse
      @arg_pars.check
      @config = Config.load from: @arg_pars.args[:config]
      p @config
    end

    def run()
        # Create email message
        email = EMail::Message.new
        email.from    "noreply@datalite.cz", "Notify"
        email.to      "mares@datalite.cz", "Martin Mareš"
        email.subject "Test email - hello world!"
        email.message <<-EOM
          Testovací email.

          --
          Martin M.
          EOM

        # Email HTML email body
        email.message_html <<-EOM

        EOM

        config = EMail::Client::Config.new("oracleas.datalite.cz", 2525)

        # Create SMTP client object
        client = EMail::Client.new(config)

        client.start do
          # In this block, default receiver is client
          send(email)
        end
    end

  end

  app = App.new
  # app.run

end
