class LowFareStatistic
  include Comparable

  attr_reader :origin, :destination, :departure_dates, :return_dates,
              :low_outbound_price, :low_return_price, :checked_on

  def initialize(origin, destination, updated_since = 2.hours.ago)
    @origin             = origin
    @destination        = destination
    @low_outbound_price = 0
    @low_return_price   = 0
    @departure_dates    = [DateUnknown.new]
    @return_dates       = [DateUnknown.new]
    @checked_on         = DateUnknown.new
    statistics(updated_since)
  end

  def total_price
    low_outbound_price + low_return_price
  end

  def create_low_fare
    low_fare = LowFare.where(origin_id: origin, destination_id: destination).first_or_initialize
    low_fare.price = total_price
    low_fare.save!
  end

  def calendar_url(travelers=2, outbound=true)
    ("https://fly.hawaiianairlines.com/Calendar/Default.aspx" +
     "?qrys=qres&Trip=RT" +
     "&adult_no=#{travelers}" +
     "&departure=#{origin.code}" +
     "&out_day=#{departure_dates.first.strftime('%d')}" +
     "&out_month=#{departure_dates.first.strftime('%m')}" +
     "&return_day=#{return_dates.first.strftime('%d')}" +
     "&return_month=#{return_dates.first.strftime('%m')}" +
     "&destination=#{destination.code}")
  end

  private

  def statistics(updated_since)
    outbound_attr       = one_way_low_fare_stat(origin, destination, updated_since)
    @low_outbound_price = outbound_attr[:price]
    @departure_dates    = outbound_attr[:dates]
    @checked_on         = outbound_attr[:checked_on]

    return_attr         = one_way_low_fare_stat(destination, origin, updated_since)
    @return_dates       = return_attr[:dates]
    @low_return_price   = return_attr[:price]
  end

  def one_way_low_fare_stat(origin, destination, updated_since, return_after = Time.now.to_date)
    attributes    = { price: 0, dates: [DateUnknown.new], checked_on: DateUnknown.new }
    related_fares = LowUpcomingFareQuery.new(origin, destination)
                    .find_all(updated_since, return_after)

    if related_fares.size > 0
      lowest_price            = related_fares.first.price
      attributes[:dates]      = valid_dates(related_fares, lowest_price)
      attributes[:price]      = lowest_price
      attributes[:checked_on] = related_fares.order(:updated_at).last.updated_at
    end

    attributes
  end

  def valid_dates(fares, price)
    fares.reject { |fare| fare.price != price }.map(&:departure_date).sort
  end
end

# NullDate object
class DateUnknown
  def strftime(*)
    'Unknown'
  end
end
