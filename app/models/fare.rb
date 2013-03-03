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

  validates_presence_of :price, :departure_date, :origin_id, :destination_id

  # if price does not change for departure_date, update updated_at
  def smart_save
    existing = find_existing(origin, destination, departure_date)

    puts "found #{existing.price.to_s}"

    if existing && existing.price == self.price
      existing.touch
      true
    else
      puts "price change, new record"
      self.save
    end
  end

  private

  def find_existing(origin,  destination, departure_date)
    Fare.where(origin_id: self.origin).
      where(destination_id: self.destination).
      where(departure_date: self.departure_date).
      order(:created_at).last
  end
end
