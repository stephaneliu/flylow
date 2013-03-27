class LowFare < ActiveRecord::Base
  attr_accessible :destination_id, :origin_id, :price

  belongs_to :destination, class_name: 'City'
  belongs_to :origin, class_name: 'City'

  validates :origin, presence: true
  validates :destination, presence: true 
  validates :price, presence: true
end
