class ConnectionsController < ApplicationController
  before_action :set_connection, only: %i[show edit update destroy onboard_update]

  def index
    # for new connection creation
    @user = current_user
    @connection = Connection.new(frequency: 1.month)
    # for page proper
    @connections = process_query(policy_scope(Connection).live)
  end

  def show
    @checkin = Checkin.new
    @user = @connection.user
    authorize @connection
  end

  # def new
  #   if user_signed_in?
  #     @user = current_user
  #     @connection = Connection.new(frequency: 1.month)
  #     authorize @connection
  #   else
  #     redirect_to new_user_session_path
  #   end
  # end

  def create
    if user_signed_in?
      @connection = Connection.new(connection_params)
      @user = current_user
      @connection.user = @user
      @connection.live = Time.now
      authorize @connection
      if @connection.save
        respond_to do |format|
          format.html { redirect_to connections_path, notice: "Connection was successfully added" }
          format.js
        end
      else
        render 'new'
      end
    else
      redirect_to new_user_session_path
    end
  end

  # def edit
  #   authorize @connection
  # end

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

  def onboard
    # for new connection creation
    @user = current_user
    @connection = Connection.new(frequency: 1.month)
    # for page proper
    @connections = policy_scope(Connection).pending.order(created_at: :desc)
  end

  def onboard_update
    authorize @connection
    if params[:target].present?
      @connection.live = Time.now
      case params[:target]
      when 'weekly' then @connection.frequency = 1.week
      when 'monthly' then @connection.frequency = 1.month
      when 'quarterly' then @connection.frequency = 3.month
      when 'yearly' then @connection.frequency = 1.year
      when 'never' then @connection.frequency = nil
      else @connection.live = nil
      end
      if @connection.live && @connection.save
        # all good
      end
    end
    respond_to do |format|
      format.html { redirect_to onboard_connections_path }
      format.js do
        @connections = policy_scope(Connection).pending.order(created_at: :desc)
      end
    end
  end

  private

  def connection_params
    if params[:other].present? && params[:other][:frequency_value].present? &&
       params[:other][:frequency_unit].present? &&
       helpers.duration_units.include?(params[:other][:frequency_unit].to_sym)
      params[:connection][:frequency] = params[:other][:frequency_value].to_i.zero? ?
        nil : params[:other][:frequency_value].to_i.send(params[:other][:frequency_unit].to_sym)
    end
    params.require(:connection).permit(:first_name, :last_name, :description,
                                       :birthday, :live, :frequency, :email,
                                       :facebook, :linkedin, :instagram, :twitter,
                                       :photo)
  end

  def set_connection
    @connection = Connection.find(params[:id])
  end

  def process_query(connections)
    if params[:query].present?
      connections = connections.search(params[:query])
    end
    # this must be the last step because for some cases we lose the ActiveRecord::Relation
    if params[:sort].present?
      case params[:sort]
      when 'live' then connections = connections.order(live: :desc)
      when 'checkin' then connections = connections.sort_by(&:checkin_time_sortable)
      else connections = connections.order(live: :desc)
      end
    else
      connections = connections.order(live: :desc)
    end
    return connections
  end
end
