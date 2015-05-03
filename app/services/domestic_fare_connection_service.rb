# Class gets fares from external site given origin and destination
# airport code of origin and destination on new
class DomesticFareConnectionService
  attr_reader :mechanize, :origin, :destination, :travelers
  attr_accessor :departure_date

  def initialize(travelers = 4)
    @mechanize = mechanize_agent
    @travelers = travelers
  end

  # outbound - origin to destination
  def get_content(origin, destination, departure_date, outbound = true)
    @origin         = origin.upcase
    @destination    = destination.upcase
    @departure_date = departure_date.to_date

    mechanize.get(calendar_url(outbound)).content
  end

  private

  def mechanize_agent
    Mechanize.new.tap { |mech| mech.ssl_version = 'SSLv3' }
  end

  def format_date(date)
    date.strftime('%m/%d/%y')
  end

  # rubocop:disable Style/LineEndConcatenation
  def calendar_url(outbound = true)
    # origin must be uppercase - very picky
    "https://fly.hawaiianairlines.com/Calendar/Calendar.aspx" +
      "?orig=#{origin}" +
      "&dest=#{destination}" +
      "&traveler=#{travelers}" +
      "&depDate=#{format_date(departure_date)}" +
      "&owORob=#{outbound}" +
      "&isDM=false" +
      "&isRoundTrip=true" +
      "&isEAward=false"
  end
end
