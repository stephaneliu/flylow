# Scrap obtains fare page for origin to destination
#
class Scrap
  extend Forwardable

  def_delegators :@connection,
                 :origin, :destination, :travelers, :departure_date

  def initialize(connection)
    @connection = connection
  end

  # Endpoint distinguishes between origin -> destination from reverse
  def get_days_with_fare(outbound = true)
    page = @connection.get_content(outbound)

    parse_page(page, :find_cheap).merge(parse_page(page, !:find_cheap))
  end

  private

  def parse_page(page, cheap_fares = true)
    return {} unless page.present?
    element_to_find = element_class(cheap_fares)

    page.css(element_to_find).each_with_object({}) do |day_fare, day_with_fare|
      date                = parse_date_from_element(day_fare)
      fare                = parse_fare_from_element(day_fare)
      day_with_fare[date] = fare
    end
  end

  def element_class(cheap_fares)
    if cheap_fares
      'td.CalendarDayCheapest'
    else
      'td.CalendarDayDefault'
    end
  end

  def parse_date_from_element(element)
    year  = departure_date.year
    month = departure_date.month
    day   = parse_day_from_element(element)

    Date.parse("#{year}/#{month}/#{day}")
  end

  def parse_fare_from_element(element)
    element.css('.Fare').first.content[1..-1].to_f
  end

  def parse_day_from_element(element)
    element.css('.Text').first.content
  end
end
