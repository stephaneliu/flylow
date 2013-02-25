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
    cookie_jar  = Mechanize::CookieJar.new

    cookie      = Mechanize::Cookie.new(
                    name:   'FlightSearch1.destination',
                    value:  'PDX',
                    domain: 'fly.hawaiianairlines.com',
                    secure: true,
                    path:   '/')

    cookie_jar << cookie
  end
end
