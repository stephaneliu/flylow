# == Schema Information
#
# Table name: low_fares
#
#  id              :integer          not null, primary key
#  origin_id       :integer
#  destination_id  :integer
#  price           :decimal(8, 2)    default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  departure_dates :text(65535)
#  departure_price :decimal(8, 2)    default(0.0)
#  return_dates    :text(65535)
#  return_price    :decimal(8, 2)    default(0.0)
#  url             :text(65535)
#  last_checked    :datetime
#

# ORM for LowFare record
class LowFare < ActiveRecord::Base
  belongs_to :destination, class_name: 'City'
  belongs_to :origin, class_name: 'City'

  validates :origin, presence: true
  validates :destination, presence: true
  validates :departure_price, presence: true
  validates :return_price, presence: true

  serialize :departure_dates
  serialize :return_dates

  def total_price
    departure_price + return_price
  end

  def formatted_departure_dates
    return unless departure_dates

    format_dates(departure_dates)
  end

  def formatted_return_dates
    return unless return_dates

    format_dates(return_dates)
  end

  private

  def format_dates(dates)
    dates.map { |date| date.strftime('%-m/%d') }.join(', ')
  end
end
