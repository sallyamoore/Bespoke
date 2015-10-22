class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth'] || params
    if auth_hash["uid"]
      login_by_provider(auth_hash)
    elsif auth_hash[:session] && auth_hash[:session][:username]
      login_by_username(auth_hash)
    else
      redirect_to root_path, flash: { error: MESSAGES[:failed_authentication] }
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def login_by_provider(auth_hash)
    user = User.find_or_create_from_omniauth(auth_hash)
    if user
      login_user(user)
      redirect_to root_path, flash: { success: MESSAGES[:success] }
    end

  end

  def login_by_username(auth_hash)
    user = User.find_by(username: auth_hash[:session][:username])
    # Add email option?
    # || User.find_by(email: auth_hash[:session][:email])
    if user && user.activated? && user.authenticate(auth_hash[:session][:password])
      login_user(user)
      # params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to root_path, flash: { success: MESSAGES[:success] }
    elsif user && !user.activated?
      flash[:alert] = MESSAGES[:not_activated]
      redirect_to root_url
    else
      redirect_to root_path, flash: { error: MESSAGES[:failed_authentication] }
    end
  end

end
