class AddNodeIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :node_id, :string
  end
end
