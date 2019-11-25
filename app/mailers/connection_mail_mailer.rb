class ConnectionMailMailer < ApplicationMailer
  def hello
    @greeting = "Hi"
    @user = User.find(params[:user_id])
    @connection = Connection.find(params[:connection_id])
    @body = params[:body]
    mail to: @connection.email, subject: params[:subject], body: params[:body]
  end

  def test_mail
    assert !ActionMailer::Base.deliveries.empty?
  end
end
