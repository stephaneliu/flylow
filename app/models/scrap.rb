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

    parse_page(page)
  end

  private

  def parse_page(page)
    return {} unless page.present?

    find_elements = ['td.CalendarDayDefault', 'td.CalendarDayCheapest']

    find_elements.each_with_object({}) do |find_element, day_with_fare|
      page.css(find_element).each do |day_fare|
        date, fare          = parse_date_and_fare_from(day_fare)
        day_with_fare[date] = fare
      end
    end.compact
  end

  def parse_date_and_fare_from(element)
    [parse_date_from(element), parse_fare_from(element)]
  end

  def parse_date_from(element)
    return unless (day = find_content_with_identity(element, '.Text'))

    year  = departure_date.year
    month = departure_date.month

    Date.parse("#{year}/#{month}/#{day}")
  end

  def parse_fare_from(element)
    return unless (price = find_content_with_identity(element, '.Fare'))

    price[1..-1].to_f
  end

  def find_content_with_identity(element, identifier)
    return unless (el = element.css(identifier).first)
    el.content
  end
end
