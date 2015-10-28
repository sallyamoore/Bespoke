class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      login_user(user)
      redirect_to user_path(user), flash: { success: MESSAGES[:user_activated] }
    else
      redirect_to root_path, flash: { error: MESSAGES[:bad_link] }
    end
  end

end
