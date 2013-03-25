class LowFareStatistic

  include Comparable

  attr_reader :origin, :destination, :departure_dates, :return_dates,
    :low_outbound_price, :low_return_price, :checked_on

  def initialize(attributes) 
    @origin             = attributes[:origin]
    @destination        = attributes[:destination]
    @low_outbound_price = attributes.fetch(:low_outbound_price, 0)
    @low_return_price   = attributes.fetch(:low_return_price, 0)
    @departure_dates    = attributes.fetch(:departure_dates, [])
    @return_dates       = attributes.fetch(:return_dates, [])
    @checked_on         = attributes.fetch(:checked_on, DateUnknown.new)
  end

  def total_price
    low_outbound_price + low_return_price
  end

  def self.low_upcoming_fares_for(cities, updated_since=2.hours.ago)
    destinations  = cities.dup

    cities.each_with_object([]) do |origin, low_fares|
      destinations.each do |destination|
        low_fare = self.roundtrip_low_fare_stat(origin, destination, updated_since)

        unless low_fare.total_price < 1
          low_fares << low_fare
        end
      end
    end.compact.sort
  end

  def <=>(other)
    if origin.blank?
      -1
    elsif other.origin.blank?
      1
    elsif origin.name == other.origin.name
      destination.name <=> other.destination.name
    else
      origin.name <=> other.origin.name
    end
  end

  def calendar_url(travelers=2, outbound=true)
    ("https://fly.hawaiianairlines.com/Calendar/Default.aspx" +
     "?qrys=qres&Trip=RT" +
     "&adult_no=#{travelers}" +
     "&departure=#{origin.code}" +
     "&destination=#{destination.code}")
  end

  private

  def self.roundtrip_low_fare_stat(origin, destination, updated_since)
    attributes                      = {origin: origin, destination: destination}
    
    outbound_attr                   = self.one_way_low_fare_stat(origin, destination, updated_since)
    attributes[:low_outbound_price] = outbound_attr.delete(:price)
    attributes[:departure_dates]    = outbound_attr.delete(:dates)

    return_after                    = attributes[:departure_dates].first
    return_attr                     = self.one_way_low_fare_stat(destination, origin, updated_since,
                                                                 return_after)
    attributes[:low_return_price]   = return_attr.delete(:price)
    attributes[:return_dates]       = return_attr.delete(:dates)

    LowFareStatistic.new(attributes.merge(outbound_attr))
  end

  def self.one_way_low_fare_stat(origin, destination, updated_since, return_after=Time.now.to_date)
    attributes  = {price: 0, dates: [], checked_on: DateUnknown.new}
    fares       = Fare.upcoming_for(origin, destination).
                    where('updated_at > ?', updated_since).
                    where('departure_date >= ?', return_after).
                    order(:price)

    if fares.present?
      lowest_price            = fares.first.price
      valid_for_dates         = fares.reject {|fare| fare.price != lowest_price}.
                                  map(&:departure_date).sort
      attributes[:price]      = lowest_price
      attributes[:dates]      = valid_for_dates
      attributes[:checked_on] = fares.order(:updated_at).last.updated_at
    end

    attributes
  end
end

class DateUnknown
  def strftime(format)
    "Unknown"
  end
end
