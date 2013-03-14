class FareStatistic

  attr_reader :origin, :destination, :departure_dates, :return_dates,
    :low_outbound_price, :low_return_price, :checked_on

  def initialize(attributes) 
    @origin             = attributes[:origin]
    @destination        = attributes[:destination]
    @low_outbound_price = attributes.fetch(:low_outbound_price, 0)
    @low_return_price   = attributes.fetch(:low_return_price, 0)
    @departure_dates    = attributes.fetch(:departure_dates, [])
    @return_dates       = attributes.fetch(:return_dates, [])
    @checked_on         = attributes[:checked_on]
  end

  def self.low_upcoming_fares_for(cities, updated_since=1.hour.ago)
    destinations  = cities.dup
    reported      = []

    cities.each_with_object([]) do |origin, low_fares|
      reported << origin

      destinations.each do |destination|
        next if reported.include? destination
        low_fares << self.roundtrip_low_fare_stat(origin, destination, updated_since)
      end
    end.compact.sort
  end

  def <=>(other)
    return -1 if self.origin.blank?
    return 1 if other.origin.blank?
    self.origin.name <=> other.origin.name
  end

  private

  def self.roundtrip_low_fare_stat(origin, destination, updated_since)
    lowest_outbound_attributes  = self.one_way_low_fare_stat(origin, destination, updated_since)
    lowest_return_attributes    = self.one_way_low_fare_stat(destination, origin, updated_since, false)

    if lowest_outbound_attributes.present? or lowest_return_attributes.present?
      FareStatistic.new(lowest_outbound_attributes.merge(lowest_return_attributes))
    end
  end

  def self.one_way_low_fare_stat(origin, destination, updated_since, outbound=true)
    attributes = {}

    if (fares = Fare.upcoming_for(origin, destination).where('updated_at > ?', updated_since).order(:price)).present?
      attributes[:origin]       = origin
      attributes[:destination]  = destination
      lowest_price              = fares.first.price
      valid_for_dates           = fares.reject {|fare| fare.price != lowest_price}.
                                        map(&:departure_date).sort
      if outbound
        attributes[:low_outbound_price] = lowest_price
        attributes[:departure_dates]    = valid_for_dates
      else
        attributes[:low_return_price]   = lowest_price
        attributes[:return_dates]       = valid_for_dates
      end
      attributes[:checked_on]           = fares.first.updated_at
    end
    attributes
  end

end
