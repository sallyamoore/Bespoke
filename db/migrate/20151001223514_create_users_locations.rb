class CreateUsersLocations < ActiveRecord::Migration
  def change
    create_table :users_locations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :location, index: true
    end
  end
end
