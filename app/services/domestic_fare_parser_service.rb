# Object parses content with fare info
class DomesticFareParserService
  attr_accessor :departure_date

  def initialize(departure_date = 1.day.from_now.to_date)
    @departure_date = departure_date
  end

  def parse(content)
    return {} unless content.present?

    find_elements = ['td.CalendarDayDefault', 'td.CalendarDayCheapest']

    find_elements.each_with_object({}) do |find_element, day_with_fare|
      content.css(find_element).each do |day_fare|
        date, fare          = parse_date_and_fare_from(day_fare)
        day_with_fare[date] = fare
      end
    end.compact
  end

  private

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
