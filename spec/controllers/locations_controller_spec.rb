require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  describe "GET #index" do
    it "should be successful" do
      get :index
      expect(response).to be_ok
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "POST #create" do
    it "creates a Location" do
      @user = create :user
      session[:user_id] = @user.id
      expect {
        post :create, location: attributes_for(:location)
      }.to change(Location, :count).by(1)
      expect(Location.count).to eq 1
    end
  end

  describe "GET #retrieve_nodes" do
    before :each do
      @loc1 = create :location, node_number: 1, node_id: 1, latitude: 52.01, longitude: 5.01
      @loc2 = create :location, node_number: 2, node_id: 2, latitude: 52.11, longitude: 5.11
      @loc3 = create :location, node_number: 3, node_id: 3, latitude: 52.21, longitude: 5.21
      @loc4 = create :location, node_number: 4, node_id: 4, latitude: 53.11, longitude: 6.11

      get :retrieve_nodes, swLat: 52, swLng: 5, neLat: 53, neLng: 6
    end

    it "returns json" do
      expect(response.header['Content-Type']).to include 'application/json'
    end

    let(:parsed_response) { JSON.parse response.body }
    it "is a hash of bike node information" do
      expect(parsed_response).to be_an_instance_of Hash
    end

    it "includes id, tags, lat, and lon keys" do
      expect(parsed_response["data"].first.keys).to eq(["id", "tags", "lat", "lon"])
    end

    it "retrieves the bike nodes in bounds" do
      expect(parsed_response["data"].count).to eq 3
      expect(parsed_response["data"][0]["id"]).to include(@loc1.id.to_s)
      expect(parsed_response["data"][1]["id"]).to include(@loc2.id.to_s)
      expect(parsed_response["data"]).to include({"id"=>"3", "tags"=>{"rcn_ref"=>3}, "lat"=>52.21, "lon"=>5.21})
    end

    it "does not retrieve bike nodes outside bounds" do
      expect(parsed_response["data"]).to_not include({"id"=>"4", "tags"=>{"rcn_ref"=>4}, "lat"=>53.11, "lon"=>6.11})

    end

    it "response with status 200" do
      expect(parsed_response["status"]).to eq 200
    end
  end
end
