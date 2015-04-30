class AddDefaultPriceToLowFare < ActiveRecord::Migration
  def change
    change_column_default :low_fares, :price, 0.0
    change_column_default :low_fares, :departure_price, 0.0
    change_column_default :low_fares, :return_price, 0.0
  end
end
