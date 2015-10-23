class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # user.update_attribute(:activated,    true)
      # user.update_attribute(:activated_at, Time.zone.now)
      user.activate
      login_user(user)
      redirect_to root_path, flash: { success: MESSAGES[:user_activated] }
    else
      redirect_to root_path, flash: { error: MESSAGES[:bad_link] }
    end
  end

end
