class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # user.update_attribute(:activated,    true)
      # user.update_attribute(:activated_at, Time.zone.now)
      user.activate
      login_user(user)
      flash[:success] = MESSAGES[:user_activated]
      redirect_to root_path
    else
      flash[:error] = MESSAGES[:bad_link]
      redirect_to root_path
    end
  end

end
