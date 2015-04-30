class AddCachingToLowFare < ActiveRecord::Migration
  def change
    add_column :low_fares, :departure_dates, :text
    add_column :low_fares, :departure_price, :decimal, precision: 8, scale: 2
    add_column :low_fares, :return_dates, :text
    add_column :low_fares, :return_price, :decimal, precision: 8, scale: 2
    add_column :low_fares, :url, :text
    add_column :low_fares, :last_checked, :datetime
  end
end
