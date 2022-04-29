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

        if @config.mail.from.name
          email.from @config.mail.from.address, @config.mail.from.name
        else
          email.from @config.mail.from.address
        end

        if @config.mail.to
          to_addrs =  @config.mail.to.as(Array(SendEmail::Email))
          to_addrs.each do |to|
            if to.name
              email.to to.address, to.name
            else
              email.to to.address
            end
          end
        end

        if @config.mail.cc
          cc_addrs =  @config.mail.cc.as(Array(SendEmail::Email))
          cc_addrs.each do |cc|
            if cc.name
              email.cc cc.address, cc.name
            else
              email.cc cc.address
            end
          end
        end

        if @config.mail.bcc
          bcc_addrs =  @config.mail.bcc.as(Array(SendEmail::Email))
          bcc_addrs.each do |bcc|
            if bcc.name
              email.bcc bcc.address, bcc.name
            else
              email.bcc bcc.address
            end
          end
        end

        email.subject @config.mail.subject

        email.message File.read(@config.mail.templates.body.text)
        email.message_html File.read(@config.mail.templates.body.html.as(String)) if @config.mail.templates.body.html

        if @arg_pars.args_multi.size > 0
          attachments = @arg_pars.args_multi[:attachment]
          attachments.each do |attachment|
            email.attach attachment, file_name: Path[attachment].basename
          end
        end

        smtp_conf = EMail::Client::Config.new(@config.smtp.hostname, @config.smtp.port, helo_domain: @config.smtp.helo_domain)
        client = EMail::Client.new(smtp_conf)

        client.start do
          send(email)
        end
    end

  end

  app = App.new
  app.run

end
