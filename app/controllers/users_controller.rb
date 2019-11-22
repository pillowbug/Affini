class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update]
  skip_after_action :verify_authorized


  def show
    @checkin = Checkin.new
    @user = current_user
    @connection = Connection.new
    # TODO: investigate doing below with scopes
    @connections_checkin = @user.connections.select(&:checkin_deadline).sort_by(&:checkin_deadline).first(10)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user), :notice =>"Profile successfully updated"
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
end
