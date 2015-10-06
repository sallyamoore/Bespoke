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
end
