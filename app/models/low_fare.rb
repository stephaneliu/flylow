class LowFare < ActiveRecord::Base
  belongs_to :destination, class_name: 'City'
  belongs_to :origin, class_name: 'City'

  validates :origin, presence: true
  validates :destination, presence: true 
  validates :price, presence: true
end
