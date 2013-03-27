class CreateLowFares < ActiveRecord::Migration
  def change
    create_table :low_fares do |t|
      t.integer :origin_id
      t.integer :destination_id
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
