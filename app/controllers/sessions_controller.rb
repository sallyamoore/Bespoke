class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth'] || params

    if auth_hash["uid"]
      user = User.find_or_create_from_omniauth(auth_hash)
    elsif auth_hash[:session] && auth_hash[:session][:username]
      user = User.find_by(username: auth_hash[:session][:username])
      # Add email option?
      # || User.find_by(email: auth_hash[:session][:email])
    end

    if user && auth_hash["uid"]
      login_user(user)
      redirect_to root_path, flash: { success: MESSAGES[:success] }

    elsif user && user.authenticate(auth_hash[:session][:password])
      if user.activated?
        login_user(user)
        # params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to root_path, flash: { success: MESSAGES[:success] }
      else
        flash[:alert] = MESSAGES[:not_activated]
        redirect_to root_url
      end

    else
      redirect_to root_path, flash: { error: MESSAGES[:failed_authentication] }
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

end
