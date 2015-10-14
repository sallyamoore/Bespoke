class LocationsController < ApplicationController

  def index
    # if user_id is in session, get user; otherwise, set user to nil.
    user = session[:user_id] ? User.find(session[:user_id]) : nil
    # if user, set @username to user.username; else, set username to guest.
    @username = user ? user.username : "guest"
  end
end
