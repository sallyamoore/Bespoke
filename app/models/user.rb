class User < ActiveRecord::Base
  # Associations --------------------
  has_secure_password
  has_and_belongs_to_many :locations

  # Validations ---------------------
  validates :username, :email, :password_digest, presence: true, uniqueness: true
  validates :email, format: /@+.+\.+./
  validates :provider, presence: true

  def self.find_or_create_from_omniauth(auth_hash)
    uid = auth_hash[:uid]
    provider = auth_hash[:provider]

    user = User.where(uid: uid, provider: provider).first_or_initialize
    user.email = auth_hash[:info][:email]
    user.username = auth_hash[:info][:name]

    return user.save ? user : nil
  end

end
