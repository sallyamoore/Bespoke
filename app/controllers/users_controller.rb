class UsersController < ApplicationController
  # get_user_by_id is in ApplicationController
  before_action :get_user_by_id, only: [:edit]

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

  def create # create a new user and log in
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      flash[:alert] = MESSAGES[:activation_email]
      redirect_to root_path
    else
      flash[:error] = MESSAGES[:registration_error]
      render :new
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
