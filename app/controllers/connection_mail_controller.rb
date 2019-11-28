class ConnectionMailController < ApplicationController
  before_action :set_connection

  def send_connection_email
    authorize @connection
    # ConnectionMailMailer.with(
    #   user_id: current_user.id,
    #   connection_id: @connection.id,
    #   subject: params[:email][:subject],
    #   body: params[:email][:body]
    # ).hello.deliver_now
    create_email_checkin
    redirect_to connection_path(@connection)
    flash.now[:notice] = "Email sent to #{@connection.first_name}"
  end

  def create_email_checkin
    @checkin = Checkin.new(
      user_id: current_user.id,
      time: Time.now,
      description: 'Email Sent: ' + params[:email][:subject],
      completed: true
    )
    @checkin.user = current_user
    @checkin.connections << @connection
    @checkin.save
  end

  private

  def set_connection
    @connection = Connection.find(params[:connection_id])
  end
end
