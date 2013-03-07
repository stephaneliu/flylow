class FareStatistic

  attr_reader :origin, :destination, :departure_dates, :return_dates, :checked_on

  def initialize(params) 
    @origin             = params[:origin]
    @destination        = params[:destination]
    @low_outbound_price = params[:low_outbound_price]
    @low_return_price   = params[:low_return_price]
    @departure_dates    = params[:departure_dates]
    @return_dates       = params[:return_dates]
    @checked_on         = params[:checked_on]
  end

  def low_outbound_price
    return 0 if @low_outbound_price.blank?
    @low_outbound_price
  end

  def low_return_price
    return 0 if @low_return_price.blank?
    @low_return_price
  end

  def self.low_upcoming_fares_for(cities, updated_since=1.hour.ago)
    destinations  = cities.dup
    reported      = []

    cities.sort_by {|city| city.name}.each_with_object([]) do |origin, low_fares|
      reported << origin

      destinations.each do |destination|
        next if reported.include? destination
        low_fares << self.roundtrip_low_fare_stat(origin, destination, updated_since)
      end
    end.compact
  end

  def merge(other)
    self.instance_variables.each_with_object(FareStatistic.new({})) do |attrib, new_fare_statistic|
      val = if other.instance_variable_get(attrib.to_sym).blank?
              self.instance_variable_get(attrib.to_sym)
            else
              other.instance_variable_get(attrib.to_sym)
            end
      new_fare_statistic.instance_variable_set(attrib.to_sym, val)
    end
  end

  private

  def self.roundtrip_low_fare_stat(origin, destination, updated_since)
    lowest_outbound_stat = self.one_way_low_fare_stat(origin, destination, updated_since)
    if lowest_outbound_stat.present?
      lowest_outbound_stat.merge(self.one_way_low_fare_stat(destination, origin, updated_since, outbound=false))
    end
  end

  def self.one_way_low_fare_stat(origin, destination, updated_since, outbound=true)
    fares = Fare.upcoming_for(origin, destination).
      where('updated_at > ?', updated_since).order(:price)

    if fares.present?
      lowest_fare                           = fares.first
      departure_dates                       = fares.reject {|fare| fare.price != lowest_fare.price}.map(&:departure_date)
      low_outbound_price, low_return_price  = outbound ? [lowest_fare.price, nil] : [nil, lowest_fare.price]
      departure_dates, return_dates         = outbound ? [departure_dates, nil] : [nil, departure_dates]
      checked_on                            = outbound ? lowest_fare.updated_at : nil

      FareStatistic.new(origin: origin, destination: destination,
                        low_outbound_price: low_outbound_price, low_return_price: low_return_price,
                        departure_dates: departure_dates, return_dates: return_dates,
                        checked_on: checked_on)
    end
  end

end
