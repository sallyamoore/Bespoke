class LocationsController < ApplicationController

  def index
    # if user_id is in session, get user; otherwise, set user to nil.
    @user = session[:user_id] ? User.find(session[:user_id]) : nil

    # if user, set @username to user.username; else, set username to guest.
    @username = @user ? @user.username : "guest"
  end

  def create
    # if logged_in?
    #   user = User.find(session[:user_id])
    # end

    location = Location.find_or_create_by(node_id: params[:node_id])
    location.node_number = params[:node_number]
    location.latitude = params[:latitude]
    location.longitude = params[:longitude]

    if location.save && logged_in?
      user = User.find(session[:user_id])

      user.locations << location
      render :text => "", status: 200
    elsif location.save
      render :text => "", status: 200
    else
      render :text => "", status: 400
    end
  end

  def destroy
    location = Location.find(params[:location_id])
    correct_login(location)
    user = params[:user_id]
    user.locations.delete(location)

    redirect_to user_path(session[:user_id]), alert: "Location deleted."
  end

  private

  def logged_in?
    session[:user_id] ? true : false
  end

  def location_params
    params.require(:location).permit(:node_id, :node_number, :latitude, :longitude)
  end

  def correct_login(object)
    unless session[:user_id] == object.user_id
      redirect_to user_path(session[:user_id]), flash: { error: MESSAGES[:wrong_login] }
    end
  end

end
