class Fare < ActiveRecord::Base
  attr_accessible :price, :departure_date, :origin_id, :destination_id, :origin, :destination, :comments

  belongs_to :origin, class_name: 'City'
  belongs_to :destination, class_name: 'City'
end
