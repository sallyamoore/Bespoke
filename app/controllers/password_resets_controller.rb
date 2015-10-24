class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  # valid_user is in ApplicationController
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = MESSAGES[:password_reset]
      redirect_to root_url
    else
      flash.now[:error] = MESSAGES[:no_email]
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      login_user(@user)
      flash[:success] = "Password has been reset."
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:error] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end

  # Confirms a valid user for password reset.
  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      flash[:error] = MESSAGES[:not_activated]
      redirect_to root_url
    end
  end
end
