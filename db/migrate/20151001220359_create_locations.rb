class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :node_number
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
