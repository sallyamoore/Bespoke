require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
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

  describe "POST #create registers new user (through app, not third party)" do
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
        post :create, user: attributes_for(:user, email: "blah")
      end

      it "does not create a User" do
        expect(User.count).to eq 0
      end

      it "renders the new User page when save is unsuccessful" do
        expect(subject).to render_template(:new)
      end

      it "displays an error message" do
        expect(flash[:error]).to_not be nil
      end
    end
  end

  describe "GET #show" do
    before :each do
      @user = create :user
      session[:user_id] = 1
    end

    it "responds successfully with an HTTP 200 status code" do
      get :show, id: @user

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it  "renders the #show template" do
      get :show, id: @user
      expect(subject).to render_template :show
    end

    it "shows the selected user" do
      get :show, id: @user
      expect { assigns(:user).to eq(@user) }
    end
  end


  xdescribe "GET #edit" do

  end

  xdescribe "POST #update" do

  end

  xdescribe "DELETE #destroy" do

  end

end
