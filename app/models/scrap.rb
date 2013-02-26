class Scrap
  def initialize
    @agent = Mechanize.new
    set_cookies
    @page = @agent.get "https://fly.hawaiianairlines.com/reservations"
  end

  def page
    @page
  end

  private

  def set_cookies
    # @TODO - read from YAML file
    #
    cookie_jar  = Mechanize::CookieJar.new

    { 'FlightSearch1.tripType' => 'RT',
      'FlightSearch1.travelers' => '2',
      'FlightSearch1.destination' => 'PDX',
      'FlightSearch1.departureDate' => '3/1/2013',
      'FlightSearch1.returnDate' => '3/11/2013',
      'FlightSearch1.altCity' => 'false' }.each do |name, value|
        cookie_jar << Mechanize::Cookie.new(
                        name:   name,
                        value:  value,
                        domain: 'fly.hawaiianairlines.com',
                        secure: true,
                        path:   '/')

  end
end
