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

  include Comparable

  attr_accessible :name, :region, :airport_code

  scope :favorites, where(favorite: true)
  scope :domestic, where(region: 'Domestic')
  scope :international, where(region: 'International')

  def code
    airport_code
  end

  def self.oahu
    @oahu ||= where(airport_code: 'HNL').first
  end

end
