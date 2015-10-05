class Location < ActiveRecord::Base
  # Associations --------------------
  has_and_belongs_to_many :users

  # Validations ---------------------
  validates :latitude, :longitude, presence: true, numericality: true
  validates :node_number, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than: 100 
  }

end
