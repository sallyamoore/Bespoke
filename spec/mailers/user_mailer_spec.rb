require 'rails_helper'

RSpec.describe UserMailer do
  describe 'account_activation' do
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
end


# test "account_activation" do
#   user = users(:michael)
#   user.activation_token = User.new_token
#   mail = UserMailer.account_activation(user)
#   assert_equal "Account activation", mail.subject
#   assert_equal [user.email], mail.to
#   assert_equal ["noreply@example.com"], mail.from
#   assert_match user.name,               mail.body.encoded
#   assert_match user.activation_token,   mail.body.encoded
#   assert_match CGI::escape(user.email), mail.body.encoded
# end
