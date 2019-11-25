class ConnectionMailController < ApplicationController
  def send_connection_email
    @connection = Connection.find(params[:connection_id])
    authorize @connection
    ConnectionMailMailer.with(user_id: current_user.id,
                              connection_id: @connection.id,
                              subject: params[:email][:subject],
                              body: params[:email][:body]).hello.deliver_now
    redirect_to connection_path(@connection)
  end
end
