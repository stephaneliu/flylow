# Class gets fares from external site given origin and destination
# airport code of origin and destination on new
class DomesticFareConnectionService < BaseConnectionService
  attr_reader :origin, :destination
  attr_accessor :departure_date

  def initialize(travelers = 4)
    super
  end

  # outbound - origin to destination
  def get_content(origin, destination, departure_date)
    @origin         = origin.upcase
    @destination    = destination.upcase
    @departure_date = departure_date.to_date

    mechanize.get(calendar_url).content
  end

  private

  def format_date(date)
    date.strftime('%m/%d/%y')
  end

  # rubocop:disable Style/LineEndConcatenation
  def calendar_url
    # origin must be uppercase - very picky
    "https://fly.hawaiianairlines.com/Calendar/Calendar.aspx" +
      "?orig=#{origin}" +
      "&dest=#{destination}" +
      "&traveler=#{travelers}" +
      "&depDate=#{format_date(departure_date)}" +
      "&owORob=true" +
      "&isDM=false" +
      "&isRoundTrip=true" +
      "&isEAward=false"
  end
end
