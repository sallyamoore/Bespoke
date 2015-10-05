class User < ActiveRecord::Base
  # Associations --------------------
  has_secure_password
  has_and_belongs_to_many :locations

  # Validations ---------------------
  validates :username, :email, :password_digest, presence: true, uniqueness: true
  validates :email, format: /@+.+\.+./ 

end
