class ConnectionsController < ApplicationController
  before_action :set_connection, only: %i[show edit update destroy]

  def index
    @user = current_user
    @connection = Connection.new
    if params[:query].present?
      sql_query = " \
        connections.first_name @@ :query \
        OR connections.last_name @@ :query \
        OR connections.description @@ :query \
        OR connections.email @@ :query \
        OR connections.facebook @@ :query \
        OR connections.linkedin @@ :query \
        OR connections.instagram @@ :query \
        OR connections.twitter @@ :query \
        "
      @connections = policy_scope(Connection).live.where(sql_query, query: "%#{params[:query]}%")
    else
      @connections = policy_scope(Connection).live
    end
  end

  def show
    @checkin = Checkin.new
    @user = current_user
    authorize @connection
  end

  def new
    if user_signed_in?
      @user = current_user
      @connection = Connection.new
      authorize @connection
    else
      redirect_to new_user_session_path
    end
  end

  def create
    if user_signed_in?
      # TODO: sanitize me
      if params[:other].present? && params[:other][:frequency_value].present? && params[:other][:frequency_unit].present?
        params[:connection][:frequency] = params[:other][:frequency_value] == "0" ? nil : params[:other][:frequency_value].to_i.send(params[:other][:frequency_unit])
      end
      @connection = Connection.new(connection_params)
      @user = current_user
      @connection.user = @user
      authorize @connection
      if @connection.save
        redirect_to connection_path(@connection), notice: "Connection was successfully added"
      else
        render 'new'
      end
    else
      redirect_to new_user_session_path
    end
  end

  def edit
    authorize @connection
  end

  def update
    authorize @connection
    # TODO: sanitize me
      if params[:other].present? && params[:other][:frequency_value].present? && params[:other][:frequency_unit].present?
        params[:connection][:frequency] = params[:other][:frequency_value] == "0" ? nil : params[:other][:frequency_value].to_i.send(params[:other][:frequency_unit])
      end
    if @connection.update(connection_params)
      redirect_to connection_path(@connection), notice: "Connection was successfully updated"
    else
      render :edit
    end
  end

  def destroy
    authorize @connection
    @connection.destroy
    redirect_to connections_path
  end

  private

  def connection_params
    params.require(:connection).permit(:first_name, :last_name, :description, :birthday, :frequency, :email, :facebook, :linkedin, :instagram, :twitter, :photo, :live)
  end

  def set_connection
    @connection = Connection.find(params[:id])
  end
end
