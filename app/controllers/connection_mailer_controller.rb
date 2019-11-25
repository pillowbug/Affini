class ConnectionMailerController < ApplicationController

  def send_connection_email
    ConnectionMailMailer.with(user_id: current_user.id,
                              connection_id: params[:id],
                              subject: params[:email][:subject],
                              body: params[:email][:body])
  end
end
