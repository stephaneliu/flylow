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

# ORM object representing City
class City < ActiveRecord::Base
  include Comparable

  validates :name, :airport_code, presence: true, uniqueness: true
  validates :region, inclusion: { in: %w(Domestic International) }

  scope :favorites,     -> { where(favorite: true) }
  scope :domestic,      -> { where(region: 'Domestic') }
  scope :international, -> { where(region: 'International') }

  def code
    airport_code
  end

  def self.oahu
    find_by(airport_code: 'HNL')
  end
end
