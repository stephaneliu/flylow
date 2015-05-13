class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :low_fares, :origin_id
    add_index :low_fares, :destination_id
    add_index :fares, :origin_id
    add_index :fares, :destination_id
    add_index :roles, ["resource_id", "resource_type"]
  end
end
