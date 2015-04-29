# == Schema Information
#
# Table name: low_fares
#
#  id              :integer          not null, primary key
#  origin_id       :integer
#  destination_id  :integer
#  price           :decimal(8, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  departure_dates :text
#  departure_price :decimal(8, 2)
#  return_dates    :text
#  return_price    :decimal(8, 2)
#  url_reference   :string(255)
#  last_checked    :string(255)
#

# ORM for LowFare record
class LowFare < ActiveRecord::Base
  belongs_to :destination, class_name: 'City'
  belongs_to :origin, class_name: 'City'

  validates :origin, presence: true
  validates :destination, presence: true
  validates :price, presence: true
end
