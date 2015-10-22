class LocationsController < ApplicationController
  # valid_user and get_user_by_id are in ApplicationController
  before_action :get_user_by_id, only: [:create]
  before_action :valid_user, only: [:create]
  before_action :login_user, only: [:create]

  def index
    # if user_id is in session, get user; otherwise, set user to nil.
    user = session[:user_id] ? User.find(session[:user_id]) : nil

    # if user, set @username to user.username; else, set username to guest.
    @username = user ? user.username : "guest"
  end

  def create # before_actions: valid_user, get_user_by_id, login_user
    if @user
      raise
    else
      flash[:error] = MESSAGES[:login_required]
    end
  end




end
