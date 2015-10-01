class User < ActiveRecord::Base
  # Associations --------------------
  has_secure_password
  has_and_belongs_to_many :locations

  # Validations ---------------------
  # Add email Validation
end
