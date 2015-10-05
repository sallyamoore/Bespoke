class Location < ActiveRecord::Base
  # Associations --------------------
  has_and_belongs_to_many :users

  # Validations ---------------------
  # latitude, longitude: presence
  # node_number: integer > 1 and < 100

end
