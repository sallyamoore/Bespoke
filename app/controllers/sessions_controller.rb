class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth'] || params

    unless auth_hash == nil || auth_hash["uid"] == nil
      @user = auth_hash["uid"] ? User.find_or_create_from_omniauth(auth_hash) : User.find_by(username: auth_hash[:session][:username])
    end

    if @user && (auth_hash["uid"] || @user.authenticate(auth_hash[:session][:password]))
      login_user(@user)
    else
      redirect_to root_path, flash: { error: MESSAGES[:failed_authentication] }
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

end
