class CheckinsController < ApplicationController
  before_action :set_checkin, only: %i[show edit update destroy]

  def index
    @checkins = current_user.checkins
  end

  def show
  end

  def new
    if user_signed_in?
      @user = current_user
      @checkin = Checkin.new
    else
      redirect_to new_user_session_path
    end
  end

  def create
    if user_signed_in?
      @checkin = Checkin.new(checkin_params)
      @user = current_user
      @checkin.user = @user
      if @checkin.save
        redirect_to checkin_path(@checkin), :notice => "Checkin was successfully added"
      else
        render 'new'
      end
    else
      redirect_to new_user_session_path
    end
  end

  def edit
  end

  def update
    if @checkin.update(checkin_params)
      redirect_to checkin_path(@checkin), :notice => "Checkin was successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @checkin.destroy
    redirect_to checkins_path
  end

  private

  def checkin_params
    params.require(:checkin).permit(:first_name, :last_name, :description, :birthday, :frequency, :email, :facebook, :linkedin, :instagram, :twitter, :photo)
  end

  def set_checkin
    @checkin = Checkin.find(params[:id])
  end
end
