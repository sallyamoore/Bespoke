class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  helper_method :current_user

  MESSAGES = {
    login_required: "You have to be logged in to do that!",
    failed_authentication: "Invalid username/password combination. :( Please try again.",
    logout_first: "You are currently logged in. Log out to create a new account.",
    activation_email: "Please check your email to activate your account.",
    registration_error: "Registration failed. Please check your entries and try again.",
    bad_link: "Invalid activation link.",
    user_activated: "Account activated!",
    success: "Success!",
    not_activated: "Account not activated. Check your email for the activation link.",
    password_reset: "Please check your email for password reset instructions.",
    no_email: "Email address not found."

  }

  private

  def get_user_by_id
    @user = User.find(params[:id])
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def login_user(user)
    session[:user_id] = user.id
  end

  # Confirms a valid user.
  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      flash.now[:error] = MESSAGES[:not_activated]
      redirect_to root_url
    end
  end

end
