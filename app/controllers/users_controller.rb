class UsersController < ApplicationController
  # get_user_by_id is in ApplicationController
  before_action :get_user_by_id, only: [ :edit, :update, :show, :destroy ]
  before_action :active_user, only: [ :show, :edit, :update ]

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

  def show
    if !@user
      flash[:error] = MESSAGES[:login_required]
      redirect_to root_path
    elsif @user.id != session[:user_id]
      flash[:error] = MESSAGES[:wrong_login]
      redirect_to root_path
    else
      @locations = Location.where(user_id: session[:user_id])
    end
  end

  def edit; end

  def update
    @user.update(user_params)

    if @user.save
      redirect_to user_path(@user.id), flash: { success: MESSAGES[:success] }
    else
      redirect_to user_path(@user.id), flash: { error: MESSAGES[:failed_save] }
    end

  end

  def destroy
    reset_session
    @user.destroy
    redirect_to root_path, flash: { info: "Account deleted."}
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
