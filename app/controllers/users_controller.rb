class UsersController < ApplicationController

  def index; end

  def new
    if session[:user_id].nil?
      @user = User.new
      render :new
    else
      flash[:error] = MESSAGES[:logout_first]
      redirect_to root_path
    end
  end

  def create # create a new logged in user
    @user = User.new(user_params)
    if @user.save
      login_user(@user)
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
