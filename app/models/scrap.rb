class Scrap
  def initialize
    # @agent  = Mechanize.new
    # @agent.ssl_version = 'SSLv3'
    # # @agent.cookie_jar = set_cookies
    # @page   = @agent.get start_url
    # form    = get_form(@page)

    # fill_form(form)
    # page = agent.submit(form)

  end

  def working_example
    agent = Mechanize.new
    agent.ssl_version = 'SSLv3'
    page = agent.get "https://fly.hawaiianairlines.com/Calendar/Calendar.aspx?orig=PDX&dest=HNL&traveler=1&isDM=false&isRoundTrip=true&depDate=5/9/2013&owORob=false&clickedDate=5/9/2013&isEAward=false"
  end

  def start_url
    "https://fly.hawaiianairlines.com/reservations"
  end

  def page
    @page
  end

  def get_form(page)
    raise "Unexpected forms on page" if page.forms.size > 1
    page.forms.first
  end

  def post_url
    "https://fly.hawaiianairlines.com/Calendar/Calendar.aspx"
  end

  def params
    { "orig"=>"PDX", "dest"=>"HNL", "traveler"=>"1", "isDM"=>"false", "isRoundTrip"=>"true", "depDate"=>"5/9/2013", "owORob"=>"false", "clickedDate"=>"5/9/2013", "isEAward"=>"false"}
  end

  def fill_form(form)
    { 'TripType_Name' => 'Roundtrip',
      'TripType_Code' => 'RT',
      'Travelers_Name' => '2 Travelers',
      'Travelers_Code' => '2',
      'Origin_Name' => 'Oahu - Honolulu, HI (HNL)',
      'Origin_Code' => 'HNL',
      'Destination_Name' => 'Portland, OR (PDX)',
      'Destination_Code' => 'PDX',
      'departureDate' => 5.days.from_now.strftime("%m/%d/%y").gsub(/^0/,'').gsub(/\/0/, '/'),
      'returnDate' => 15.days.from_now.strftime("%m/%d/%y").gsub(/^0/,'').gsub(/\/0/, '/')
    }.each do |field, value|
      fields_in_form = form.fields_with(name: Regexp.new(field)).size

      if fields_in_form == 0
        raise "Could not find #{field} in form"
      elsif fields_in_form > 1
        raise "More than one #{field} field in form"
      end

      form[form.field_with(name: Regexp.new(field)).name] = value
    end
  end

  def set_cookies
    # @TODO - read from YAML file
    #
    cookie_jar  = Mechanize::CookieJar.new

    { 'FlightSearch1.tripType' => 'RT',
      'FlightSearch1.travelers' => '2',
      'FlightSearch1.destination' => 'PDX',
      'FlightSearch1.departureDate' => '3/4/2013',
      'FlightSearch1.returnDate' => '3/14/2013',
      'FlightSearch1.altCity' => 'false' }.each do |name, value|
        cookie_jar << Mechanize::Cookie.new(
                        name:   name,
                        value:  value,
                        domain: 'fly.hawaiianairlines.com',
                        secure: true,
                        path:   '/')
    end
    cookie_jar
  end

end
