# Preview all emails at http://localhost:3000/rails/mailers/connection_mail_mailer
class ConnectionMailMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/connection_mail_mailer/hello
  def hello
    ConnectionMailMailer.hello
  end

end
