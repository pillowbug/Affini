class ConnectionMailMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.connection_mail_mailer.hello.subject
  #
  def hello
    @greeting = "Hi"

    mail to: 'gerard.cabarse@gmail.com', subject: "Params lol"
  end
end
