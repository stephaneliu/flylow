# Object parses content with fare info
class DomesticFareParserService < BaseFareParserService
  def initialize(parser = Nokogiri::HTML)
    super
  end

  def parse(content)
    return {} unless content.present?

    fail ArgumentError, "departure_date not assigned" unless departure_date.present?

    parsed          = parser.parse(content)
    days_with_fares = {}

    find_fares_from_content(parsed) { |date, fare| days_with_fares[date] = fare }
    days_with_fares.compact
  end

  private

  def find_fares_from_content(content)
    find_elements = ['td.CalendarDayDefault', 'td.CalendarDayCheapest']

    find_elements.each do |find_element|
      content.css(find_element).each do |day_fare|
        yield parse_date_and_fare_from(day_fare)
      end
    end

    @departure_date = nil
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
