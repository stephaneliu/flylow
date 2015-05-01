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

# ORM object representing Fare for application
class Fare < ActiveRecord::Base
  belongs_to :origin, class_name: 'City'
  belongs_to :destination, class_name: 'City'

  validates :price, :departure_date, :origin_id, :destination_id, presence: true

  def smart_save
    existing = find_existing
    (existing && existing.price == price) ? existing.touch : save
  end

  private

  def find_existing
    Fare.where(origin: origin, destination: destination, departure_date: departure_date)
      .order(:created_at).last
  end
end
