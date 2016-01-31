class UsersController < ApplicationController
  before_action :setup_users

  def index
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to :users, notice: "Auth token: #{@user.auth}"
    else
      render :index
    end
  end

  def destroy
    User.destroy(params[:id])
    redirect_to :users, notice: "User deleted"
  end

private
  def setup_users
    @users = User.all
    @user = User.new
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
