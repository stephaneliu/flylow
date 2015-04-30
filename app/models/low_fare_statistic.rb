# Compute statistics for low fares
class LowFareStatistic
  include Comparable

  attr_reader :low_fare, :departure_dates, :return_dates,
              :low_outbound_price, :low_return_price, :checked_on, :updated_since

  def initialize(origin, destination, updated_since = 2.hours.ago)
    @updated_since      = updated_since
    @low_fare           = LowFare.where(origin_id: origin, destination_id: destination)
                          .first_or_initialize
  end

  def total_price
    low_fare.departure_price + low_fare.return_price
  end

  def create_low_fare
    one_way_low_fare_stat(:outbound)
    one_way_low_fare_stat(!:outbound)

    if low_fare.departure_dates && low_fare.return_dates
      low_fare.url_reference = calendar_url
    end

    low_fare.save!
    low_fare
  end

  private

  def calendar_url(travelers = 2)
    ("https://fly.hawaiianairlines.com/Calendar/Default.aspx\
?qrys=qres&Trip=RT\
&adult_no=#{travelers}\
&departure=#{low_fare.origin.code}\
&out_day=#{get_date_element(:day, low_fare.departure_dates.first)}\
&out_month=#{get_date_element(:month, low_fare.departure_dates.first)}\
&return_day=#{get_date_element(:day, low_fare.return_dates.first)}\
&return_month=#{get_date_element(:month, low_fare.return_dates.first)}\
&destination=#{low_fare.destination.code}")
  end

  def get_date_element(element, date)
    case element
    when :month
      date.strftime('%m')
    when :day
      date.strftime('%d')
    else
      ''
    end
  end

  def one_way_low_fare_stat(departure_flight = true, return_after = Time.now.to_date)
    related_fares = LowUpcomingFareQuery.new(low_fare.origin, low_fare.destination, departure_flight)
      .find_all(updated_since, return_after)

    return unless related_fares.count > 0

    lowest_price = related_fares.first.price

    if departure_flight
      low_fare.departure_dates = valid_dates(related_fares, lowest_price)
      low_fare.departure_price = lowest_price
    else
      low_fare.return_dates = valid_dates(related_fares, lowest_price)
      low_fare.return_price = lowest_price
    end

    low_fare.last_checked  = related_fares.order(:updated_at).last.updated_at

    low_fare
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
