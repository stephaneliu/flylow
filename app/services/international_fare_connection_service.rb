# Object obtains connection info to external resource
class InternationalFareConnectionService
  attr_reader :mechanize, :departure_date, :return_date, :travelers, :origin, :destination

  attr_writer :origin, :destination

  def initialize(travelers = 4)
    @mechanize = mechanize_agent
    @travelers = travelers
  end

  def get_content(origin, destination, departure_date, outbound = true)
    @origin      = origin
    @destination = destination

    offset_date(departure: departure_date)
    setup_session
    get_data.content
  end


  # private

  def mechanize_agent
    Mechanize.new.tap { |mech| mech.ssl_version = 'SSLv3' }
  end

  def offset_date(departure: date)
    @departure_date = departure + 3.days
    @return_date    = departure_date + 1.day
    nil
  end

  def setup_session
    mechanize.get(calendar_url)
  end

  def get_data
    mechanize.post('https://fly.hawaiianairlines.com/Reservations/2/Availability.mvc/Flights')
  end

  # rubocop:disable Style/LineEndConcatenation
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
end
