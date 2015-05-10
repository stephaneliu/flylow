# Class obtains fares from website for persistence
class FareFetcherService
  attr_reader :cities, :connection, :destination,
              :dates, :origin, :routes, :parser

  def initialize(connection: DomesticFareConnectionService.new,
                 parser: DomesticFareParserService.new,
                 routes:,
                 dates: [1.day.from_now.localtime,
                         1.month.from_now, 2.months.from_now,
                         3.months.from_now, 4.months.from_now])
    @connection = connection
    @parser     = parser
    @dates      = dates
    @routes     = routes
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def fares
    routes.each_with_object([]) do |route, fares|
      @origin, @destination = route
      start_time            = Time.zone.now

      Rails.logger.info("## Start | #{origin.code} / #{destination.code} |")

      obtain_fare do |fare|
        fare.smart_save
        fares << fare
      end

      update_low_fare_cache

      Rails.logger.info("## End | #{origin.code} / #{destination.code} | \
duration: #{Time.zone.now - start_time}")
    end
  end

  private

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def obtain_fare
    dates.each do |month|
      start_time = Time.zone.now

      get_start             = Time.zone.now
      month_in_words        = month.strftime('%m-%d-%Y')
      content               = connection.get_content(origin.code, destination.code, month)
      parser.departure_date = month
      get_end               = Time.zone.now

      Rails.logger.info("### Start | #{month_in_words} Get, Parse, Save | ")
      Rails.logger.info("#### Get | | duration: #{get_end - get_start}")

      parse_start = Time.zone.now
      parser.parse(content)
      parse_end = Time.zone.now
      Rails.logger.info("#### Parse | | duration: #{parse_end - parse_start}")

      [:departure, !:departure].each do |departing|
        direction_as_word = departing ? "departing" : "return"
        departing_from    = departing ? origin : destination
        going_to          = departing ? destination : origin
        fares             = parser.fares(departing)

        if fares.size > 0
          Rails.logger.info("#### Save | #{fares.size} #{direction_as_word} fares found |")
        end

        fares.each do |date, price|
          yield Fare.new(price: price, departure_date: date,
                         origin: departing_from, destination: going_to)
        end
      end
      Rails.logger.info("### End | #{month_in_words} Get, Parse, Save | \
duration: #{Time.zone.now - start_time}")
    end
  end

  def update_low_fare_cache
    start_time = Time.zone.now
    LowFareStatistic.new(origin, destination).create_low_fare
    end_time = Time.zone.now
    Rails.logger.info("#### Caching | | duration: #{end_time - start_time}")
  end
end
