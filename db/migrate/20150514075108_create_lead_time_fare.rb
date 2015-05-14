class CreateLeadTimeFare < ActiveRecord::Migration
  def change
    create_table :lead_time_fares do |t|
      t.integer :origin_id, index: true
      t.integer :destination_id, index: true
      t.date    :departure_date 
      t.decimal :price, precision: 8, scale: 2
      t.integer :lead_days
    end
  end
end
