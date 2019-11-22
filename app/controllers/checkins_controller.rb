class CheckinsController < ApplicationController
  before_action :set_checkin, only: %i[show edit update destroy]

  def index
    @user = current_user
    @checkins = policy_scope(Checkin)
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
      @connection = Connection.find(params[:checkin][:connections])
      @checkin.user = @user
      @checkin.connections << @connection
      @checkin.time.past? ? @checkin.completed = true : @checkin.completed = false
      authorize @checkin
      if @checkin.save
        redirect_to connection_path(@connection), notice: "Checkin was successfully added"
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
      redirect_to root_path, notice: "Checkin was successfully updated"
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

  def checkin_params
    params.require(:checkin).permit(:description, :time, :rating, :completed)
  end

  def set_checkin
    @checkin = Checkin.find(params[:id])
  end
end
