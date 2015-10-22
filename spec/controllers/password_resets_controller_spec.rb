require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  describe "#create" do
    context "invalid email address entered" do
      before :each do
        create :user
        post :create, password_reset: { email: "not-an-email" }
      end

      it "displays an error message" do
        expect(flash[:error]).to_not be nil
      end

      it "renders the new view" do
        expect(subject).to render_template(:new)
      end
    end

    context "valid email address entered" do

      before :each do
        @user = create :user
        post :create, password_reset: { email: @user.email }
        @assigns = assigns(:user)
      end

      it "sends an email" do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end

      it "generates a new reset token each time" do
        expect(@assigns.reset_token).to_not be_nil
        expect(@user.reset_digest).to_not eq(@user.reload.reset_digest)
      end

      it "displays a message" do
        expect(flash[:info]).to_not be nil
      end

      it "redirects to root" do
        expect(subject).to redirect_to(root_path)
      end
    end
  end

  describe "#edit -- password reset form" do
    before :each do
      @user = create :user
      post :create, password_reset: { email: @user.email }
      @assigns = assigns(:user)
    end

    context "wrong email in url" do
      it "displays an error and redirects to root path" do
        get :edit, id: @assigns.reset_token, email: "not-me@not.me"
        expect(flash[:error]).to_not be nil
        expect(subject).to redirect_to(root_path)
      end
    end

    context "inactivated user" do
      it "displays an error and redirects to root path" do
        @user.activated = false
        get :edit, id: @assigns.reset_token, email: "pusheen@kittybloggens.com"
        expect(flash[:error]).to_not be nil
        expect(subject).to redirect_to(root_path)
      end
    end

    context "invalid token" do
      it "displays an error and redirects to root path" do
        get :edit, id: "hey-ima-token", email: "pusheen@kittybloggens.com"
        expect(flash[:error]).to_not be nil
        expect(subject).to redirect_to(root_path)
      end
    end

    # context "valid password reset url" do
    #   it "renders the edit view" do
    #     get :edit, id: @assigns.reset_token, email: "pusheen@kittybloggens.com"
    #   end
    # end



  end
end
