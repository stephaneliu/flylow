# Class obtains fares from website for persistence
class FareFetcherService
  attr_reader :cities, :connection, :destination,
              :logger, :months, :oahu, :origin

  def initialize(connection, logger = Logger.new(STDOUT),
                 months = [1.day.from_now.localtime,
                           1.month.from_now, 2.months.from_now,
                           3.months.from_now, 4.months.from_now])
    @connection = connection
    @months     = months
    @cities     = City.favorites
    @oahu       = City.oahu
    @logger     = logger
  end

  def fares
    cities.each do |origin|
      @origin = origin

      destinations.each do |destination|
        @destination = destination

        next unless origin_or_destination_oahu?
        obtain_fare
        update_low_fare_cache
      end
    end
  end

  private

  def destinations
    cities.reject { |city| city == origin }
  end

  def origin_or_destination_oahu?
    origin == oahu || destination == oahu
  end

  def obtain_fare
    months.each do |month|
      parser  = Scrap.new(month)
      content = connection.get_content(origin.code, destination.code, month)

      parser.parse(content).each do |day, content_fare|
        Fare.new(price: content_fare, departure_date: day,
                 origin: origin, destination: destination).smart_save
      end
    end
  end

  def update_low_fare_cache
    LowFareStatistic.new(origin, destination).create_low_fare
  end
end
