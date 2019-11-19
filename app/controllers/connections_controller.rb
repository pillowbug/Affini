class ConnectionsController < ApplicationController
  before_action :set_connection, only: %i[show edit update destroy]

  def index
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
      @connections = policy_scope(Connection).where(sql_query, query: "%#{params[:query]}%")
    else
      @connections = policy_scope(Connection)
    end
  end

  def show
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
    params.require(:connection).permit(:first_name, :last_name, :description, :birthday, :frequency, :email, :facebook, :linkedin, :instagram, :twitter, :photo)
  end

  def set_connection
    @connection = Connection.find(params[:id])
  end
end
