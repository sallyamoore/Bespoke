require 'rails_helper'

RSpec.describe AccountActivationsController, type: :controller do

  before :each do
    @user = create :user
  end

  it "does not activate with invalid token" do
    get :edit, id: "invalid", email: @user.email
    expect(@user.activated?).to be(false)
    expect(session[:user_id]).to be(nil)
  end

  it "does not activate with valid token and invalid email" do
    get :edit, id: @user.activation_token, email: 'wrong'
    expect(@user.activated?).to be(false)
    expect(session[:user_id]).to be(nil)
  end

  it "Activates user with valid token and valid email" do
    get :edit, id: @user.activation_token, email: @user.email
    expect(session[:user_id]).to eq(@user.id)
    expect(@user.activated?)
  end
end
