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

  # describe "GET #retrieve_nodes" do
  #   before :each do
  #     create :location
  #     build :location, node_number: 1, latitude: 52.01, longitude: 5.01
  #     get :retrieve_nodes
  #   end
  # end
end
