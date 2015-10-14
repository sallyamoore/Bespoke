require 'rails_helper'
require 'pry'

RSpec.describe SessionsController, type: :controller do

  describe "GET #create_with_provider" do
    context "logging in via github with valid params" do
      before :each do
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      end

      it "sets user_id for the session" do
        get :create_with_provider, provider: :github
        expect(session[:user_id]).to eq(1)
      end

      it "creates a user" do
        expect {
          get :create_with_provider, provider: :github
          }.to change(User, :count).by(1)
      end

      it "redirects to root_path" do
        get :create_with_provider, provider: :github
        expect(response).to redirect_to root_path
      end
    end

    context "attempted login via github with invalid params" do
      let(:invalid_params) { {
        :provider => 'github',
        :uid => nil,
        info: {email: "a@b.com", username: "Ada"}
      } }

      it "does not create a user" do
        request.env['omniauth.auth'] = invalid_params
        expect {
          get :create_with_provider, provider: :github
          }.to change(User, :count).by(0)
      end
    end

  #   context "logging in via twitter - valid params" do
  #     before :each do
  #       request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
  #     end
  #
  #     it "redirects to root_path" do
  #       get :create, provider: :twitter
  #
  #       expect(response).to redirect_to root_path
  #     end
  #
  #     it "creates a user" do
  #       expect {
  #         get :create, provider: :twitter
  #         }.to change(User, :count).by(1)
  #     end
  #
  #     it "sets user_id and access token" do
  #       get :create, provider: :twitter
  #       expect(session[:user_id]).to eq(1)
  #       expect(session[:access_token]).to eq(ENV['INSTAGRAM_ACCESS_TOKEN'])
  #     end
  #   end
  #
  #   context "logging in via twitter - invalid params" do
  #     let(:invalid_params) { {
  #       :provider => 'twitter',
  #       :uid => '12345',
  #       info: {email: "a@b.com", nickname: "Ada"},
  #       credentials: { token: 'token' }
  #     } }
  #
  #     it "does not create a user" do
  #       get :create, invalid_params
  #
  #       expect {
  #         get :create, invalid_params
  #         }.to change(User, :count).by(0)
  #     end
  #   end
  # end # GET #create
  #
  # describe "DELETE #destroy" do
  #   context "valid params" do
  #     before :each do
  #       @user = create :user
  #       session[:user_id] = @user.id
  #     end
  #
  #     it "resets the session" do
  #       delete :destroy
  #
  #       expect(session[:user_id]).to eq(nil)
  #     end
  #
  #     it "redirects to the home page" do
  #       delete :destroy
  #       expect(subject).to redirect_to(root_path)
  #     end
  #   end
  end

end
