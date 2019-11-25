class ConnectionMailMailer < ApplicationMailer
  def hello
    @greeting = "Hi"
    @user = User.find(params[:user_id])
    @connection = Connection.find(params[:connection_id])
    @body = params[:body]
    mail to: @connection.email, subject: params[:subject]
    raise
  end
end
