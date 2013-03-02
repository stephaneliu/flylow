class CreateFares < ActiveRecord::Migration
  def change
    create_table :fares do |t|
      t.decimal :price, precision: 8, scale: 2
      t.date    :departure_date
      t.integer :origin_id
      t.integer :destination_id
      t.text :comments

      t.timestamps
    end
  end
end
