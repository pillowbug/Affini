class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def dashboard
    @user = current_user
    authorize current_user
    set_show
    render 'users/show'
  end

  def show
    authorize @user
    set_show
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
    @user = User.find(params[:id])
  end

  def set_show
    @checkin = Checkin.new
    @connection = Connection.new(frequency: 1.month)
    # TODO: investigate doing below with scopes
    @connections_checkin = @user.connections.live.select(&:checkin_deadline).sort_by(&:checkin_deadline).first(10)
  end
end
