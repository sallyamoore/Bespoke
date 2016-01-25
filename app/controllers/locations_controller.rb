class LocationsController < ApplicationController

  def index
    # if user_id is in session, get user.
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end

  def retrieve_nodes
    locations = Location.where(
      ' latitude      >= ' + params[:swLat] +
      ' AND latitude  <= ' + params[:neLat] +
      ' AND longitude >= ' + params[:swLng] +
      ' AND longitude <= ' + params[:neLng]
    )

    elements = get_nodes_in_view(locations)
    render json: { data: elements, status: 200 }.as_json
  end

  def create
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
    location = Location.find(params[:id])
    correct_login(location)
    user = User.find(params[:user_id])
    user.locations.delete(location)

    redirect_to user_path(session[:user_id]), flash: { alert: "Location deleted." }
  end

  def about; end
  def touring_info; end

  private

  def logged_in?
    session[:user_id] ? true : false
  end

  def location_params
    params.require(:location).permit(:node_id, :node_number, :latitude, :longitude)
  end

  def correct_login(object)
    unless object.users.include?(User.find(session[:user_id]))
      redirect_to user_path(session[:user_id]), flash: { error: MESSAGES[:wrong_login] }
    end
  end

  def get_nodes_in_view(locations)
    elements_array = []

    locations.each do |location|
      loc_hash =
      {
        id: location.node_id,
        tags: { rcn_ref: location.node_number },
        lat: location.latitude,
        lon: location.longitude,
      }
      elements_array << loc_hash
    end

    return elements_array
  end

end
