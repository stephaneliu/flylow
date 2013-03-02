class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :region  # domestic or international
      t.string :airport_code

      t.timestamps
    end
  end
end
