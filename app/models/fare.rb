# == Schema Information
# Schema version: 20130302222428
#
# Table name: fares
#
#  id             :integer          not null, primary key
#  price          :decimal(8, 2)
#  departure_date :date
#  origin_id      :integer
#  destination_id :integer
#  comments       :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Fare < ActiveRecord::Base
  attr_accessible :price, :departure_date, :origin_id, :destination_id, :origin, :destination, :comments

  belongs_to :origin, class_name: 'City'
  belongs_to :destination, class_name: 'City'
end
