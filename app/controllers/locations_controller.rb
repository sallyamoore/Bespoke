class LocationsController < ApplicationController

  def index
    # if user_id is in session, get user.
    @user = session[:user_id]
  end

  def retrieve_nodes
    sw_lat = params[:swLat]
    sw_lng = params[:swLng]
    ne_lat = params[:neLat]
    ne_lng = params[:neLng]
    locations = Location.where( 'latitude >= ' + sw_lat +
      ' AND latitude <= '  + ne_lat +
      ' AND longitude >= ' + sw_lng +
      ' AND longitude <= ' + ne_lng )

    elements = []
    locations.each do |location|
      loc_hash =
      {
        id: location.node_id,
        tags: { rcn_ref: location.node_number },
        lat: location.latitude,
        lon: location.longitude,
      }
      elements << loc_hash
    end
    render json: { data: elements, status: 200 }
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
