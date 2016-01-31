class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.auth = random_auth_token
    puts "AUTH: #{@user.auth}"
    if @user.save
      redirect_to :users, notice: "Auth token: #{@user.auth}"
    else
      render :new
    end
  end

private
  def random_auth_token
    (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
