# Object obtains connection info to external resource
class InternationalFareConnectionService < BaseConnectionService
  attr_reader :mechanize, :departure_date, :return_date, :travelers, :origin, :destination

  def initialize(travelers = 4)
    super
  end

  def get_content(origin, destination, departure_date, _outbound = true)
    @origin      = origin
    @destination = destination

    offset_date(departure: departure_date)
    setup_session
    mechanize.post(post_url).content
  end

  private

  def offset_date(departure: date)
    @departure_date = departure + 3.days
    @return_date    = departure_date + 1.day
    nil
  end

  def setup_session
    mechanize.get(calendar_url)
  end

  # rubocop:disable Style/LineEndConcatenation, Metrics/MethodLength, Metrics/AbcSize
  def calendar_url
    "https://fly.hawaiianairlines.com/reservations/1/default.aspx?" +
      "qrys=qres" +
      "&source=" +
      "&Trip=RT" +
      "&departure=#{origin}" +
      "&destination=#{destination}" +
      "&out_day=#{departure_date.day}" +
      "&out_month=#{departure_date.month}" +
      "&return_day=#{return_date.day}" +
      "&return_month=#{return_date.month}" +
      "&adult_no=#{travelers}" +
      "&lang=us"
  end

  def post_url
    'https://fly.hawaiianairlines.com/Reservations/2/Availability.mvc/Flights'
  end
end
