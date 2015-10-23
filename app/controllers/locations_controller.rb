class LocationsController < ApplicationController

  def index
    # if user_id is in session, get user; otherwise, set user to nil.
    user = session[:user_id] ? User.find(session[:user_id]) : nil

    # if user, set @username to user.username; else, set username to guest.
    @username = user ? user.username : "guest"
  end

  def create # before_actions: valid_user, get_user_by_id, login_user
    if logged_in?
      user = User.find(session[:user_id])
    end

    # params format should be "node_id"=>"297907053", "node_number"=>"82", "latitude"=>"52.323305", "longitude"=>"4.7945451"
    location = Location.find_or_create_by(node_id: params[:node_id])
    location.node_number = params[:node_number]
    location.latitude = params[:latitude]
    location.longitude = params[:longitude]
    if location.save
      user.locations << location
      render :text => "", status: 200
    else
      render :text => "", status: 400
    end

  end

  private

  def logged_in?
    session[:user_id] ? true : false
  end

  def location_params
    params.require(:location).permit(:node_id, :node_number, :latitude, :longitude)
  end

end
