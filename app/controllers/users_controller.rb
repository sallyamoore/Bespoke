class UsersController < ApplicationController

  def index; end

  def new
    if session[:user_id].nil?
      @user = User.new
      render :new
    else
      flash[:error] = "You are currently logged in. Log out to create a new account"
      redirect_to root_path
    end
  end

  def create # create a new logged in user
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id # creates a session - they are logged in
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
