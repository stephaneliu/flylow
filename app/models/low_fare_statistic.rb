class LowFareStatistic

  include Comparable

  attr_reader :origin, :destination, :departure_dates, :return_dates,
    :low_outbound_price, :low_return_price, :checked_on

  def initialize(origin, destination, updated_since=2.hours.ago) 
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
    low_fare = LowFare.find_or_initialize_by_origin_id_and_destination_id(origin.id, destination.id)
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

    return_after        = departure_dates.first
    return_attr         = one_way_low_fare_stat(destination, origin, updated_since, return_after)
    @return_dates       = return_attr[:dates]
    @low_return_price   = return_attr[:price]
  end

  def one_way_low_fare_stat(origin, destination, updated_since, return_after=Time.now.to_date)
    attributes    = {price: 0, dates: [DateUnknown.new], checked_on: DateUnknown.new}
    related_fares = LowUpcomingFareQuery.new(origin, destination).
                      find_all(updated_since, return_after)

    if related_fares.present?
      lowest_price            = related_fares.first.price
      attributes[:dates]      = related_fares.reject {|fare| fare.price != lowest_price}.
                                  map(&:departure_date).sort
      puts "dates: #{attributes[:dates]}"
      attributes[:price]      = lowest_price
      attributes[:checked_on] = related_fares.order(:updated_at).last.updated_at
    end

    attributes
  end
end

class DateUnknown
  def strftime(format)
    "Unknown"
  end
end
