class SessionsController < ApplicationController

  def create_with_provider
    auth_hash = request.env['omniauth.auth'] #|| params
    if auth_hash["uid"]
      @user = User.find_or_create_from_omniauth(auth_hash)
      if @user
        session[:user_id] = @user.id
        redirect_to root_path
      else
        redirect_to root_path, flash: { error: "Failed to save the user" }
      end
    else
      redirect_to root_path, flash: { error: "Failed to authenticate" }
    end
  end

  def create_with_email
    @user = User.find_by(username: params[:session][:username])

    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:error] = "Incorrect username or password" # @user.errors.messages
      redirect_to root_path
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
