# == Schema Information
# Schema version: 20130302222428
#
# Table name: cities
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  region       :string(255)
#  airport_code :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  favorite     :boolean
#

class City < ActiveRecord::Base
  attr_accessible :name, :region, :airport_code

  scope :favorites, where(favorite: true)

  def code
    self.airport_code
  end
end
