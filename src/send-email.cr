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
    end

    def run()
        # Create email message
        email = EMail::Message.new
        email.from @config.mail.from.address, @config.mail.from.name ? @config.mail.from.name : ""
        if @config.mail.to
          addrs =  @config.mail.to.as(Array(SendEmail::Email))
          addrs.each do |to|
            email.to to.address #, to.name? ? to.name : ""
          end
        end
        email.subject @config.mail.subject
        email.message <<-EOM
          Testovací email.

          --
          Martin M.
          EOM

        # Email HTML email body
        email.message_html <<-EOM
          <h1>Hello world!</h1>
        EOM

        smtp_conf = EMail::Client::Config.new(@config.smtp.hostname, @config.smtp.port)
        client = EMail::Client.new(smtp_conf)

        client.start do
          send(email)
        end
    end

  end

  app = App.new
  app.run

end
