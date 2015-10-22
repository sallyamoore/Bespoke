require 'rails_helper'

RSpec.describe UserMailer do
  describe 'account_activation email' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq('Welcome to bspoked!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@bspoked.bike'])
    end

    it 'assigns @user.username' do
      expect(mail.body.encoded).to match(user.username)
    end

    it 'assigns @user.activation_token' do
      expect(mail.body.encoded).to match(user.activation_token)
    end

    it 'links to activation path' do
      activation_link = edit_account_activation_url(
        user.activation_token,
        email: user.email
      )
      expect(mail.body.encoded).to include(activation_link)
    end
  end

  describe 'password reset email' do
    let(:user) { create(:user, reset_token: User.new_token) }
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq('bspoked password reset')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@bspoked.bike'])
    end

    it 'assigns @user.username' do
      expect(mail.body.encoded).to match(user.username)
    end

    it 'assigns @user.reset_token' do
      expect(mail.body.encoded).to match(user.reset_token)
    end

    it 'links to password reset path' do
      reset_link = edit_password_reset_url(
        id: user.reset_token,
        email: user.email
      )
      expect(mail.body.encoded).to include(reset_link)
    end
  end


end
