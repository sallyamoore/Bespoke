class User < ActiveRecord::Base
  # Associations --------------------
  has_secure_password
  has_and_belongs_to_many :locations

  # Validations ---------------------
  validates :username, :password_digest, :email, presence: true, uniqueness: true
  validates :uid, uniqueness: true
  validates :email, format: /@+.+\.+./

  def self.find_or_create_from_omniauth(auth_hash)
    uid = auth_hash[:uid]
    provider = auth_hash[:provider]

    user = User.where(uid: uid, provider: provider).first_or_initialize
    user.email = auth_hash[:info][:email]
    user.username = auth_hash[:info][:nickname]
    dummy_password = Time.now.to_i.to_s
    user.password = dummy_password
    user.password_confirmation = dummy_password

    user.save ? user : nil
  end

end
