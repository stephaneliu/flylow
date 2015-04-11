# Class obtains fares from website for persistence
class FareFetcherService
  attr_reader :logger, :months, :cities, :oahu, :origin, :destination

  def initialize(logger, months = [1.day.from_now.localtime, 1.month.from_now,
                                   2.months.from_now, 3.months.from_now,
                                   4.months.from_now])
    @months = months
    @logger = logger
    @cities = City.favorites
    @oahu   = City.oahu
  end

  def fares
    cities.each do |origin|
      @origin = origin

      destinations.each do |destination|
        @destination = destination

        next unless to_or_from_oahu?
        obtain_fare
        update_low_fare_cache
      end
    end
  end

  private

  def destinations
    cities.reject { |city| city == origin }
  end

  def to_or_from_oahu?
    origin == oahu || destination == oahu
  end

  def obtain_fare
    months.each do |month|
      connection = FareConnectionService.new(origin.code,
                                             destination.code, month)
      Scrap.new(connection).get_days_with_fare.each do |day, fare|
        fare = Fare.new(price: fare, departure_date: day, origin: origin,
                        destination: destination)
        fare.smart_save
      end
    end
  end

  def update_low_fare_cache
    LowFareStatistic.new(origin, destination).create_low_fare
  end
end
