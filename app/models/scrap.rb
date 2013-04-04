# Scrap obtains fare page for origin to destination
#
class Scrap

  attr_reader :origin, :destination, :travelers, :departure_date

  # origin / destintaion - airport.code
  def initialize(origin, destination, options={})
    options         = {} unless options.is_a? Hash # ignore unless options
    @agent          = create_secure_agent
    @origin         = origin
    @destination    = destination
    @travelers      = options[:travelers] || 2
    @departure_date = options[:departure_date] || 1.day.from_now.localtime
    @debug          = options[:debug]
  end

  # Endpoint distinguishes between origin -> destination from reverse
  def get_days_with_fare(outbound=true)
    page = get_page(outbound)

    parse_page(page, find_cheap=true).merge(parse_page(page, find_cheap=false))
  end

  private 

  def create_secure_agent
    Mechanize.new.tap {|mech| mech.ssl_version  = 'SSLv3'}
  end

  def parse_page(page, find_cheap_fares=true)
    element_class = find_cheap_fares ? 'td.CalendarDayCheapest' : 'td.CalendarDayDefault'
    page.css(element_class).each_with_object({}) do |day_fare, day_with_fare| 
      date                = parse_date_from_element(day_fare)
      fare                = parse_fare_from_element(day_fare)
      day_with_fare[date] = fare

      puts "day: #{date} / fare: #{fare}" if @debug
    end
  end

  def parse_date_from_element(element)
    Date.parse("#{departure_date.year}/#{departure_date.month}/#{parse_day_from_element(element)}")
  end

  def parse_fare_from_element(element)
   (element.css('.Fare').first.content[1..-1]).to_f
  end

  def parse_day_from_element(element)
    element.css('.Text').first.content
  end

  def get_page(outbound=true)
    Nokogiri::HTML.parse "<html>#{@agent.get(calendar_url(outbound)).content}</html>".tap {|page| puts page if @debug}
  end

  def calendar_url(outbound=true)
    ("https://fly.hawaiianairlines.com/Calendar/Calendar.aspx" +
      "?orig=#{origin}" +
      "&dest=#{destination}" +
      "&traveler=#{travelers}" +
      "&depDate=#{format_departure(@departure_date)}" +
      "&owORob=#{outbound}" +
      "&isDM=false&isRoundTrip=true&isEAward=false").tap { |url| puts url if @debug }
  end

  def format_departure(date_or_time)
    unless [ActiveSupport::TimeWithZone, Time, Date].include? date_or_time.class
      raise ArgumentError, "Expected departure_date to be a Date or Time"
    end
    date_or_time.strftime('%m/%d/%y')
  end

end
