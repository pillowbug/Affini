class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show
    authorize @user
    @checkin = Checkin.new
    @connection = Connection.new
    # TODO: investigate doing below with scopes
    @connections_checkin = @user.connections.select(&:checkin_deadline).sort_by(&:checkin_deadline).first(10)
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profile successfully updated"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :photo)
  end

  def set_user
    @user = params[:id].present? ? User.find(params[:id]) : current_user
  end
end
