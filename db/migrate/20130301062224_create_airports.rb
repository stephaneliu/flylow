class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :region  # domestic or international
      t.string :city
      t.string :code
      t.text :comment

      t.timestamps
    end
  end
end
