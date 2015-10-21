class User < ActiveRecord::Base
  attr_accessor :activation_token
  # Associations --------------------
  has_secure_password
  has_and_belongs_to_many :locations

  # Validations ---------------------
  validates :username, :password_digest, :email, presence: true, uniqueness: true
  validates :uid, uniqueness: true, allow_blank: true, allow_nil: true
  validates :email, format: /.+@+.+\.+./

  # Callbacks ----------------------
  before_create :create_activation_digest
  before_save :downcase_email

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

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

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def downcase_email
    self.email = email.downcase
  end

end
