# Preview all emails at http://localhost:3000/rails/mailers/connection_mail_mailer
class ConnectionMailMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/connection_mail_mailer/hello
  def hello
    options = {
      user_id: User.first.id,
      connection_id: Connection.first.id,
      subject: "test subject",
      body: "Test body"
    }
  ConnectionMailMailer.with(options).hello
  end

end
