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

    it "displays an error message if user is already logged in" do
      user = create :user, activated: true
      session[:user_id] = user.id
      get :new

      expect(flash[:error]).to_not be_nil
      expect(subject).to redirect_to(root_path)
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

      # it "creates a password_digest" do
      #   post :create, user: attributes_for(:user)
      #
      # end

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

  describe "GET #show, active user" do
    before :each do
      @user = create :user, activated: true
      session[:user_id] = @user.id
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
      expect(User.find(@user.id).username).to eq(@user.username)
    end
  end

  describe "GET #show, invalid user param" do
    it "will not show a user who has not activated their account" do
      @user = create :user, activated: false
      get :show, id: @user

      expect(subject).to redirect_to(root_path)
      expect(flash[:error]).to_not be nil
    end

    it "will not show a user other than the logged in user" do
      @user1 = create :user, activated: true
      @user2 = create :user, activated: true, username: "me", email: "me@me.com", uid: "394023"
      session[:user_id] = @user2.id

      get :show, id: @user1.id

      expect(subject).to redirect_to(root_path)
      expect(flash[:error]).to_not be nil
    end

    it "will not show a user when no one is logged in" do
      @user = create :user, activated: true
      session[:user_id] = nil

      get :show, id: @user.id

      expect(subject).to redirect_to(root_path)
      expect(flash[:error]).to_not be nil
    end
  end

  describe "PATCH #update" do

    before :each do
      @user = create :user, activated: true
      session[:user_id] = @user.id

      put :update, id: @user.id, user: { username: "not-pusheen"}
      @user.reload
    end

    it "updates the user record" do
      expect(response).to redirect_to(@user)

      expect(User.find(@user.id).username).to eq("not-pusheen")
      expect(@user.username).to eq("not-pusheen")
    end

    it "redirects to the user show page" do
      expect(subject).to redirect_to user_path(@user)
    end
  end

  describe "PATCH #update, user not active" do
    it "will not update a user who has not activated their account" do
      @user = create :user, activated: false
      put :update, id: @user.id, user: { username: "not-pusheen"}

      expect(subject).to redirect_to(root_path)
      expect(flash[:error]).to_not be nil
    end
  end

  describe "DELETE #destroy" do
    before :each do
      user = create :user, activated: true
      delete :destroy, id: user.id
    end

    it "deletes the user" do
      expect(User.count).to eq 0
    end

    it "redirects to the root path" do
      expect(subject).to redirect_to root_path
    end

    it "flashes an alert" do
      expect(flash[:info]).to_not be_nil
    end
  end

end
