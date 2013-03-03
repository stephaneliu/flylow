class AddFavoriteToCity < ActiveRecord::Migration
  def change
    add_column :cities, :favorite, :boolean
  end
end
