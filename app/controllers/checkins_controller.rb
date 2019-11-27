class CheckinsController < ApplicationController
  before_action :set_checkin, only: %i[show edit update destroy]

  def index
    @user = current_user
    @checkins = policy_scope(Checkin)
    @checkin = Checkin.new

    @event_json = []
    @checkins.each do |checkin|
      @event_json << { start: checkin.time.strftime('%Y-%m-%d'), title: checkin.connections.first.first_name,
                        time: checkin.time.strftime('%m-%h'), description: checkin.description
                      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @event_json }
    end
  end

  def show
    authorize @checkin
  end

  def new
    if user_signed_in?
      @user = current_user
      @checkin = Checkin.new
      authorize @checkin
    else
      redirect_to new_user_session_path
    end
  end

   def create
    if user_signed_in?
      @checkin = Checkin.new(checkin_params)
      @user = current_user
      @connection = Connection.find(whitelist_connections)
      @checkin.user = @user
      @checkin.connections << @connection
      @checkin.time.past? ? @checkin.completed = true : @checkin.completed = false
      authorize @checkin
      if @checkin.save
        redirect_to checkins_path, notice: "Checkin was successfully added"
      else
        render 'new'
      end
    else
      redirect_to new_user_session_path
    end
  end

  def edit
    authorize @checkin
  end

  def update
    authorize @checkin
    if @checkin.update(checkin_params)
      redirect_to checkins_path, notice: "Checkin was successfully updated"
    else
      render :edit
    end
  end

  def destroy
    authorize @checkin
    @checkin.destroy
    redirect_to checkins_path
  end

  private

  def whitelist_connections
    if params[:checkin][:connections].class == Array
      params[:checkin][:connections].reject{ |id| id.blank? }
    else
      params[:checkin][:connections]
    end
  end

  def checkin_params
    params.require(:checkin).permit(:description, :time, :rating, :completed)
  end

  def set_checkin
    @checkin = Checkin.find(params[:id])
  end
end
