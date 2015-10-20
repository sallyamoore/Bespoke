class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  # helper_method :current_user

  MESSAGES = {
    login_required: "You have to be logged in to do that!",
    failed_authentication: "Sign in failed. :( Please try again.",
    logout_first: "You are currently logged in. Log out to create a new account."
  }

  private

  # NOTE: Not using this currently, but may want it later.
  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def login_user(user)
    session[:user_id] = user.id
    redirect_to root_path
  end

end
