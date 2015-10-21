require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#new" do

    it "responds successfully with an HTTP 200 status code" do
      get :new

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it  "renders the #new template" do
      get :new
      expect(subject).to render_template :new
    end
  end

  describe "#create registers new user through app, not third party)" do
    context "valid User params with account activation" do
      it "creates a User" do
        expect {
          post :create, user: attributes_for(:user)
        }.to change(User, :count).by(1)
        expect(User.count).to eq 1
      end

      it "sends an email" do
        expect {
          post :create, user: attributes_for(:user)
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "does not activate before email link is clicked" do
        user = build :user
        post :create, user: attributes_for(:user)

        expect(user.activated?).to be(false)
        expect(session[:user_id]).to be(nil)
      end

    end

    context "invalid User params" do
      before :each do
        @user = {}
        @user[:user] = build :user, email: "blah"
      end

      it "does not create a User" do
        post :create, user: @user
        expect(User.count).to eq 0
      end

      it "renders the new User page when save is unsuccessful" do
        post :create, user: @user
        expect(subject).to render_template(:new)
      end

      it "displays an error message" do
        get :create, user: @user
        expect(flash[:error]).to_not be nil
      end
    end
  end
end
